var/list/obj/machinery/photocopier/faxmachine/allfaxes = list()
var/list/admin_departments = list("[GLOB.using_map.boss_name]", "Virgo-Prime Governmental Authority", "Supply")
var/list/alldepartments = list()

var/list/adminfaxes = list()	//cache for faxes that have been sent to admins

/obj/machinery/photocopier/faxmachine
	name = "fax machine"
	icon = 'icons/obj/library.dmi'
	icon_state = "fax"
	insert_anim = "faxsend"
	req_one_access = list(access_lawyer, access_heads, access_armory, access_qm)

	density = 0
	use_power = USE_POWER_IDLE
	idle_power_usage = 30
	active_power_usage = 200
	circuit = /obj/item/circuitboard/fax

	var/obj/item/card/id/scan = null // identification
	var/authenticated = 0
	var/sendcooldown = 0 // to avoid spamming fax messages
	var/department = "Unknown" // our department
	var/destination = null // the department we're sending to

/obj/machinery/photocopier/faxmachine/Initialize(mapload)
	. = ..()
	allfaxes += src
	if(!destination)
		destination = "[GLOB.using_map.boss_name]"
	if(!(("[department]" in alldepartments) || ("[department]" in admin_departments)) )
		alldepartments |= department

/obj/machinery/photocopier/faxmachine/attack_hand(mob/user as mob)
	user.set_machine(src)

	nano_ui_interact(user)

/**
 *  Display the NanoUI window for the fax machine.
 *
 *  See NanoUI documentation for details.
 */
/obj/machinery/photocopier/faxmachine/nano_ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/list/data = list()
	if(scan)
		data["scanName"] = scan.name
	else
		data["scanName"] = null
	data["bossName"] = GLOB.using_map.boss_name
	data["authenticated"] = authenticated
	data["copyItem"] = copyitem
	if(copyitem)
		data["copyItemName"] = copyitem.name
	else
		data["copyItemName"] = null
	data["cooldown"] = sendcooldown
	data["destination"] = destination

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "fax.tmpl", src.name, 500, 500)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(10) //this machine is so unimportant let's not have it update that often.

/obj/machinery/photocopier/faxmachine/Topic(href, href_list)
	if(href_list["send"])
		if(copyitem)
			if (destination in admin_departments)
				send_admin_fax(usr, destination)
			else
				sendfax(destination)

			if (sendcooldown)
				spawn(sendcooldown) // cooldown time
					sendcooldown = 0

	else if(href_list["remove"])
		if(copyitem)
			if(get_dist(usr, src) >= 2)
				to_chat(usr, "\The [copyitem] is too far away for you to remove it.")
				return
			copyitem.loc = usr.loc
			usr.put_in_hands(copyitem)
			to_chat(usr, "<span class='notice'>You take \the [copyitem] out of \the [src].</span>")
			copyitem = null

	if(href_list["scan"])
		if (scan)
			if(ishuman(usr))
				scan.loc = usr.loc
				if(!usr.get_active_held_item())
					usr.put_in_hands_or_drop(scan)
				scan = null
			else
				scan.loc = src.loc
				scan = null
		else
			var/obj/item/I = usr.get_active_held_item()
			if (istype(I, /obj/item/card/id))
				if(!usr.attempt_insert_item_for_installation(I, src))
					return
				scan = I
		authenticated = 0

	if(href_list["dept"])
		var/lastdestination = destination
		destination = input(usr, "Which department?", "Choose a department", "") as null|anything in (alldepartments + admin_departments)
		if(!destination) destination = lastdestination

	if(href_list["auth"])
		if ( (!( authenticated ) && (scan)) )
			if (check_access(scan))
				authenticated = 1

	if(href_list["logout"])
		authenticated = 0

	SSnanoui.update_uis(src)

/obj/machinery/photocopier/faxmachine/proc/sendfax(destination)
	if(machine_stat & (BROKEN|NOPOWER))
		return

	use_power(200)

	var/success = 0
	for(var/obj/machinery/photocopier/faxmachine/F in allfaxes)
		if( F.department == destination )
			success = F.receivefax(copyitem)

	if (success)
		visible_message("[src] beeps, \"Message transmitted successfully.\"")
		//sendcooldown = 600
	else
		visible_message("[src] beeps, \"Error transmitting message.\"")

/obj/machinery/photocopier/faxmachine/proc/receivefax(obj/item/incoming)
	if(machine_stat & (BROKEN|NOPOWER))
		return 0

	if(department == "Unknown")
		return 0	//You can't send faxes to "Unknown"

	flick("faxreceive", src)
	playsound(src, "sound/machines/printer.ogg", 50, 1)


	// give the sprite some time to flick
	sleep(20)

	if (istype(incoming, /obj/item/paper))
		copy(incoming)
	else if (istype(incoming, /obj/item/photo))
		photocopy(incoming)
	else if (istype(incoming, /obj/item/paper_bundle))
		bundlecopy(incoming)
	else
		return 0

	use_power(active_power_usage)
	return 1

/obj/machinery/photocopier/faxmachine/proc/send_admin_fax(mob/sender, destination)
	if(machine_stat & (BROKEN|NOPOWER))
		return

	use_power(200)

	//received copies should not use toner since it's being used by admins only.
	var/obj/item/rcvdcopy
	if (istype(copyitem, /obj/item/paper))
		rcvdcopy = copy(copyitem, 0)
	else if (istype(copyitem, /obj/item/photo))
		rcvdcopy = photocopy(copyitem, 0)
	else if (istype(copyitem, /obj/item/paper_bundle))
		rcvdcopy = bundlecopy(copyitem, 0)
	else
		visible_message("[src] beeps, \"Error transmitting message.\"")
		return

	rcvdcopy.loc = null //hopefully this shouldn't cause trouble
	adminfaxes += rcvdcopy

	//message badmins that a fax has arrived
	if (destination == GLOB.using_map.boss_name)
		message_admins(sender, "[uppertext(GLOB.using_map.boss_short)] FAX", rcvdcopy, "CentComFaxReply", "#006100")
	else if (destination == "Virgo-Prime Governmental Authority")
		message_admins(sender, "VIRGO GOVERNMENT FAX", rcvdcopy, "CentComFaxReply", "#1F66A0")
	else if (destination == "Supply")
		message_admins(sender, "[uppertext(GLOB.using_map.boss_short)] SUPPLY FAX", rcvdcopy, "CentComFaxReply", "#5F4519")
	else
		message_admins(sender, "[uppertext(destination)] FAX", rcvdcopy, "UNKNOWN")


	sendcooldown = 1800
	sleep(50)
	visible_message("[src] beeps, \"Message transmitted successfully.\"")


/obj/machinery/photocopier/faxmachine/proc/message_admins(var/mob/sender, var/faxname, var/obj/item/sent, var/reply_type, font_colour="#006100")
	var/msg = "<span class='notice'><b><font color='[font_colour]'>[faxname]: </font>[get_options_bar(sender, 2,1,1)]"
	msg += "(<a href='?_src_=holder;FaxReply=\ref[sender];originfax=\ref[src];replyorigin=[reply_type]'>REPLY</a>)</b>: "
	msg += "Receiving '[sent.name]' via secure connection ... <a href='?_src_=holder;AdminFaxView=\ref[sent]'>view message</a></span>"

	for(var/client/C in admins)
		if(check_rights((R_ADMIN|R_MOD),0,C))
			to_chat(C, msg)
			SEND_SOUND(C, sound('sound/machines/printer.ogg'))

	var/faxid = export_fax(sent)
	message_chat_admins(sender, faxname, sent, faxid, font_colour)
