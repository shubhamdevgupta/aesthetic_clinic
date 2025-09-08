class AppointmentResponse {
  final bool status;
  final int statusCode;
  final String message;
  final AppointmentData data;

  AppointmentResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory AppointmentResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentResponse(
      status: json['status'],
      statusCode: json['statuscode'],
      message: json['message'],
      data: AppointmentData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'statuscode': statusCode,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class AppointmentData {
  final Appointment appointment;

  AppointmentData({required this.appointment});

  factory AppointmentData.fromJson(Map<String, dynamic> json) {
    return AppointmentData(
      appointment: Appointment.fromJson(json['appointment']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointment': appointment.toJson(),
    };
  }
}

class Appointment {
  final String id;
  final String clientId;
  final String serviceId;
  final String doctorId;
  final String slotId;
  final String date;
  final String description;
  final String purpose;
  final String prescription;
  final int status;
  final String createdAt;
  final String updatedAt;
  final Client client;
  final Doctor doctor;
  final Service service;
  final DoctorSlot doctorSlot;

  Appointment({
    required this.id,
    required this.clientId,
    required this.serviceId,
    required this.doctorId,
    required this.slotId,
    required this.date,
    required this.description,
    required this.purpose,
    required this.prescription,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.client,
    required this.doctor,
    required this.service,
    required this.doctorSlot,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      clientId: json['clientId'],
      serviceId: json['serviceId'],
      doctorId: json['doctorId'],
      slotId: json['slotId'],
      date: json['date'],
      description: json['description'],
      purpose: json['purpose'],
      prescription: json['prescription'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      client: Client.fromJson(json['Client']),
      doctor: Doctor.fromJson(json['Doctor']),
      service: Service.fromJson(json['Service']),
      doctorSlot: DoctorSlot.fromJson(json['DoctorSlot']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'serviceId': serviceId,
      'doctorId': doctorId,
      'slotId': slotId,
      'date': date,
      'description': description,
      'purpose': purpose,
      'prescription': prescription,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'Client': client.toJson(),
      'Doctor': doctor.toJson(),
      'Service': service.toJson(),
      'DoctorSlot': doctorSlot.toJson(),
    };
  }
}

class Client {
  final String id;
  final String email;
  final String phone;
  final String firstName;
  final String lastName;
  final dynamic userDetail;

  Client({
    required this.id,
    required this.email,
    required this.phone,
    required this.firstName,
    required this.lastName,
    this.userDetail,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      email: json['email'],
      phone: json['phone'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userDetail: json['UserDetail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'firstName': firstName,
      'lastName': lastName,
      'UserDetail': userDetail,
    };
  }
}

class Doctor {
  final String id;
  final String name;
  final String title;
  final String specialization;

  Doctor({
    required this.id,
    required this.name,
    required this.title,
    required this.specialization,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: json['name'],
      title: json['title'],
      specialization: json['specialization'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'specialization': specialization,
    };
  }
}

class Service {
  final String id;
  final String name;
  final String description;
  final String price;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
    };
  }
}

class DoctorSlot {
  final String id;
  final String day;
  final String startTime;
  final String endTime;
  final int duration;

  DoctorSlot({
    required this.id,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.duration,
  });

  factory DoctorSlot.fromJson(Map<String, dynamic> json) {
    return DoctorSlot(
      id: json['id'],
      day: json['day'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
      'duration': duration,
    };
  }
}
