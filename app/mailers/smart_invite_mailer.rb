class SmartInviteMailer < ApplicationMailer
  def invite(smart_invite)
    event_ics = smart_invite.attachments.icalendar

    attachments.inline["invite.ics"] = {
      content_type: "text/calendar; charset=UTF-8; method=REQUEST",
      encoding: '7bit',
      content: event_ics,
    }

    attachments["invite.ics"] = {
      content_type: "application/ics; charset=UTF-8; method=REQUEST",
      encoding: 'base64',
      content: Base64.encode64(event_ics),
    }

    mail(
      to: smart_invite.recipient.email,
      subject: smart_invite.summary
    )
  end
end
