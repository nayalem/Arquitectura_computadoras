#include <iostream>
#include <bitset>

using namespace std;

// Función para imprimir los bits de un número en punto flotante
void printFloatBits(float f) {
    bitset<32> bits(*reinterpret_cast<unsigned*>(&f));
    cout << bits << endl;
}

int main() {
    // Leer los valores en punto flotante desde la entrada estándar
    float x, y;
    cout << "Ingrese el primer valor en punto flotante: ";
    cin >> x;
    cout << "Ingrese el segundo valor en punto flotante: ";
    cin >> y;

    // Imprimir los bits de los valores ingresados
    cout << "Bits del primer valor: ";
    printFloatBits(x);
    cout << "Bits del segundo valor: ";
    printFloatBits(y);

    // Constante para la representación con sesgo (biased representation)
    const int bias = 127;

    // Extraer los bits de signo, exponente y significando
    int sign_bit_x = (reinterpret_cast<unsigned*>(&x)[0] >> 31) & 1;
    int sign_bit_y = (reinterpret_cast<unsigned*>(&y)[0] >> 31) & 1;
    int exponent_x = (reinterpret_cast<unsigned*>(&x)[0] >> 23) & 0xFF;
    int exponent_y = (reinterpret_cast<unsigned*>(&y)[0] >> 23) & 0xFF;
    float significand_x = 1.0f + (reinterpret_cast<unsigned*>(&x)[0] & 0x7FFFFF) / static_cast<float>(1 << 23);
    float significand_y = 1.0f + (reinterpret_cast<unsigned*>(&y)[0] & 0x7FFFFF) / static_cast<float>(1 << 23);

    // Suma de los exponentes
    int exponent_sum = exponent_x + exponent_y - bias;

    // Verificar si alguno de los valores ingresados es 0
    if (x == 0 || y == 0) {
        cout << "Uno de los valores es 0. El resultado es 0." << endl;
        return 0;
    }

    // Multiplicación de los significandos
    float significand_result = significand_x * significand_y;

    // Normalización y redondeo
    while (significand_result >= 2.0f) {
        significand_result /= 2.0f;
        exponent_sum++;
    }
    if (significand_result < 1.0f) {
        significand_result *= 2.0f;
        exponent_sum--;
    }

    // Ensamblaje del resultado final
    unsigned int result_bits = 0;
    result_bits |= (sign_bit_x ^ sign_bit_y) << 31; // Signo
    result_bits |= ((exponent_sum + bias) & 0xFF) << 23; // Exponente
    result_bits |= static_cast<unsigned int>((significand_result - 1.0f) * (1 << 23)); // Significando

    // Convertir los bits de vuelta a un float
    float result = *reinterpret_cast<float*>(&result_bits);

    // Imprimir el resultado
    cout << "Resultado: " << result << endl;

    // Comparar con el resultado obtenido usando la multiplicación de punto flotante del lenguaje de programación
    float result_native = x * y;
    cout << "Resultado nativo: " << result_native << endl;

    return 0;
}















