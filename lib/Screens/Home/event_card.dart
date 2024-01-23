import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:uperitivo/Models/event_model.dart';
import 'package:uperitivo/Screens/Home/event_detail_screen.dart';
import 'package:uperitivo/Screens/Home/event_participants.dart';
import 'package:uperitivo/Utils/helpers.dart';

class EventCard extends StatefulWidget {
  final EventModel event;

  const EventCard({super.key, required this.event});

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard>
    with AutomaticKeepAliveClientMixin {
  DecorationImage getImageDecoration(EventModel event) {
    if (event.image.startsWith("http")) {
      return DecorationImage(
        fit: BoxFit.fill,
        image: NetworkImage(event.image),
      );
    } else {
      return DecorationImage(
        fit: BoxFit.fill,
        image: MemoryImage(
          event.image.isNotEmpty ? base64Decode(event.image) : Uint8List(0),
        ),
      );
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: () {
          getScreen(context, () => EventDetailScreen(event: widget.event));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12.0)),
                        image: DecorationImage(
                            image: NetworkImage(widget.event.image),
                            fit: BoxFit.cover)),
                  ),
                  Positioned(
                    top: 0,
                    right: 50,
                    child: SizedBox(
                        width: 49,
                        height: 42,
                        child: Image.asset(
                            "assets/images/${isEventOpen(widget.event.eventType, widget.event.eventTime, widget.event.untilDate, widget.event.eventDate) ? "open_badge" : "close_badge"}.png")),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 105,
                      height: 28,
                      decoration: BoxDecoration(
                          color: Color(
                              int.parse(widget.event.categoryColor.toString())),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.access_time_filled,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.event.eventTime,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: widget.event.eventType == "special"
                          ? const Color(0xffD9C301)
                          : Colors.white,
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(12.0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.event.eventName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                          widget.event.eventDescription,
                          style: const TextStyle(fontSize: 18),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          height: 1.0,
                          color: const Color(0xFF707070),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatItalianDate(widget.event.eventDate),
                              style: const TextStyle(fontSize: 20),
                            ),
                            const Text(
                              "|",
                              style: TextStyle(fontSize: 20),
                            ),
                            InkWell(
                              onTap: () {
                                getScreen(
                                    context,
                                    () => EventParticipantsScreen(
                                        event: widget.event));
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.people,
                                    color: widget.event.eventType != "special"
                                        ? const Color(0xffA0A0A0)
                                        : Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${widget.event.participants.length}",
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            const Text(
                              "|",
                              style: TextStyle(fontSize: 20),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                'Partecipa !',
                                style: TextStyle(
                                    color: widget.event.eventType != "special"
                                        ? const Color(0xffEC6500)
                                        : Colors.white,
                                    fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 105,
                      height: 28,
                      decoration: const BoxDecoration(
                          color: Color(0xff4D4D4D),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ...List.generate(
                            5,
                            (index) => Icon(
                              index < widget.event.calRating().floor()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
