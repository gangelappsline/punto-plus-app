import '../../discover/domain/business.dart';
import '../../wallet/domain/loyalty_card.dart';

const demoMemberId = 'demo-customer';
const demoBusinessId = 'cafe-origen';

List<LoyaltyCard> seedCards(DateTime now) => [
      LoyaltyCard(
        id: 'card-origen',
        businessId: demoBusinessId,
        businessName: 'Café Origen',
        category: 'CAFETERÍA',
        reward: 'Un café de tu elección',
        stamps: 6,
        target: 8,
        color: 0xFFE5EDCA,
        symbol: 'coffee',
        updatedAt: now,
      ),
      LoyaltyCard(
        id: 'card-miga',
        businessId: 'miga',
        businessName: 'Miga & Miel',
        category: 'PANADERÍA',
        reward: 'Tu pan favorito, por nuestra cuenta',
        stamps: 5,
        target: 5,
        color: 0xFFF3DDCF,
        symbol: 'bakery',
        updatedAt: now,
      ),
      LoyaltyCard(
        id: 'card-pausa',
        businessId: 'pausa',
        businessName: 'Pausa Studio',
        category: 'BIENESTAR',
        reward: 'Una clase para ti',
        stamps: 2,
        target: 6,
        color: 0xFFDBDFF2,
        symbol: 'wellness',
        updatedAt: now,
      ),
    ];

final demoBusinesses = [
  const Business(
    id: demoBusinessId,
    name: 'Café Origen',
    category: 'Café',
    address: 'Colima 145, Roma Norte, CDMX',
    latitude: 19.4195,
    longitude: -99.1604,
    description: 'Café de especialidad y buenos momentos. Un sello por visita.',
    symbol: 'coffee',
  ),
  const Business(
    id: 'miga',
    name: 'Miga & Miel',
    category: 'Comida',
    address: 'Orizaba 90, Roma Norte, CDMX',
    latitude: 19.4182,
    longitude: -99.1578,
    description:
        'Pan recién hecho, todos los días. Junta cinco sellos y elige tu favorito.',
    symbol: 'bakery',
  ),
  const Business(
    id: 'pausa',
    name: 'Pausa Studio',
    category: 'Bienestar',
    address: 'Durango 210, Roma Norte, CDMX',
    latitude: 19.4207,
    longitude: -99.1651,
    description:
        'Respira, muévete y encuentra tu pausa. Tu constancia tiene recompensa.',
    symbol: 'wellness',
  ),
];
