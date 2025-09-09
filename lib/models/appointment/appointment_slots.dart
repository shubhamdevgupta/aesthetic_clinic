class AppointmentSlots {
  final bool status;
  final int statuscode;
  final String message;
  final List<DoctorSchedule> data;

  AppointmentSlots({
    required this.status,
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory AppointmentSlots.fromJson(Map<String, dynamic> json) {
    return AppointmentSlots(
      status: json['status'] ?? false,
      statuscode: json['statuscode'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => DoctorSchedule.fromJson(e))
          .toList(),
    );
  }
}

class DoctorSchedule {
  final String doctorId;
  final Doctor doctor;
  final List<Service> services;
  final List<AvailableDate> dates;

  DoctorSchedule({
    required this.doctorId,
    required this.doctor,
    required this.services,
    required this.dates,
  });

  factory DoctorSchedule.fromJson(Map<String, dynamic> json) {
    return DoctorSchedule(
      doctorId: json['doctorId'] ?? '',
      doctor: Doctor.fromJson(json['doctor'] ?? {}),
      services: (json['services'] as List<dynamic>? ?? [])
          .map((e) => Service.fromJson(e))
          .toList(),
      dates: (json['dates'] as List<dynamic>? ?? [])
          .map((e) => AvailableDate.fromJson(e))
          .toList(),
    );
  }
}

class Doctor {
  final String id;
  final String name;
  final String title;
  final String specialization;
  final String image;

  Doctor({
    required this.id,
    required this.name,
    required this.title,
    required this.specialization,
    required this.image,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      specialization: json['specialization'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class Service {
  final String id;
  final String name;
  final String? description;
  final int price;
  final String image;
  final String? extraDetail;

  Service({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.image,
    this.extraDetail,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      price: json['price'] ?? 0,
      image: json['image'] ?? '',
      extraDetail: json['extra_detail'],
    );
  }
}

class AvailableDate {
  final String date;
  final List<Slot> slots;

  AvailableDate({
    required this.date,
    required this.slots,
  });

  factory AvailableDate.fromJson(Map<String, dynamic> json) {
    return AvailableDate(
      date: json['date'] ?? '',
      slots: (json['slots'] as List<dynamic>? ?? [])
          .map((e) => Slot.fromJson(e))
          .toList(),
    );
  }
}

class Slot {
  final String id;
  final String day;
  final String startTime;
  final String endTime;
  final int duration;
  final String createdAt;
  final String updatedAt;
  final List<dynamic> appointments;

  Slot({
    required this.id,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.createdAt,
    required this.updatedAt,
    required this.appointments,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      id: json['id'] ?? '',
      day: json['day'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      duration: json['duration'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      appointments: json['appointments'] ?? [],
    );
  }
}
