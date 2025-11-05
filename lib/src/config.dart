
// ВАЖНО: этот файл содержит реальные параметры подключения
class Config {
  // URL твоего Apps Script (Web App)
  static const backendUrl = 'https://script.google.com/macros/s/AKfycbxRA4QwUrxvtP3-NclT9GplFHkrVIp110Lu2uHOaGIlvvbZzW9kpUXdDoEijKgonGe7/exec';

  // Тот же ключ, что в apps_script_2_0.gs
  static const backendApiKey = 'Arabica2025_Vasilisa26122022';

  // (опционально) ключ Google Vision API. Оставь пустым, если не используешь.
  static const visionApiKey = '';

  // Бренды для сравнения найдено/отсутствует
  static const expectedBrands = <String>[
    'Marlboro Red','Marlboro Gold','Winston Blue','Winston Red',
    'Kent 8','Kent Silver','Parliament Night Blue','LD Silver',
    'LD Blue','Rothmans Blue','L&M Blue','L&M Red','Sobranie Black',
    'Davidoff Gold','Camel Yellow',
  ];
}
