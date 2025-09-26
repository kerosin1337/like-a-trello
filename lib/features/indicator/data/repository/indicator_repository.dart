import '/core/api/dio_client.dart';
import '/features/indicator/data/models/indicator_model.dart';
import '../../../../core/api/models/create_form_data.dart';

class IndicatorRepository {
  final DioClient _dioClient;

  IndicatorRepository(this._dioClient);

  Future<List<IndicatorModel>> getMoIndicators() async {
    try {
      final formData = await createFormData({
        "period_start": "2025-08-01",
        "period_end": "2025-08-31",
        "period_key": "month",
        "requested_mo_id": 42,
        "behaviour_key": "task,kpi_task",
        "with_result": false,
        "response_fields": "name,indicator_to_mo_id,parent_id,order",
        "auth_user_id": 40,
      });
      final response = await _dioClient.dio.post(
        '/indicators/get_mo_indicators',
        data: formData,
      );
      final data = response.data['DATA']['rows'] as List;
      return data
          .map((indicator) => IndicatorModel.fromMap(indicator))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateMoIndicator(
    int indicatorId,
    int parentId,
    int order,
  ) async {
    try {
      final formData = await createFormData({
        "period_start": "2025-08-01",
        "period_end": "2025-08-31",
        "period_key": "month",
        "indicator_to_mo_id": indicatorId,
        "field_name": "parent_id",
        "field_value": parentId,
        "auth_user_id": 40,
      });

      formData.fields.addAll([
        const MapEntry('field_name', 'order'),
        MapEntry('field_value', order.toString()),
      ]);

      await _dioClient.dio.post(
        '/indicators/save_indicator_instance_field',
        data: formData,
      );
    } catch (e) {
      rethrow;
    }
  }
}
