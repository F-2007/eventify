import '../models/ticket_model.dart';

class TicketService {

  /// Tickets List
  static List<TicketModel> tickets = [];

  /// Add Ticket
  static void addTicket(
      TicketModel ticket) {

    tickets.add(ticket);
  }

  /// Get Tickets
  static List<TicketModel> getTickets() {

    return tickets;
  }
}