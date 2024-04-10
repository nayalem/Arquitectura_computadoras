#include <iostream>
#include <vector>

using namespace std;

// Función para realizar un corrimiento aritmético hacia la derecha en un número binario
void desplazamiento_aritmetico_derecha(vector<bool>& A, vector<bool>& Q, bool& Q_1) {
    bool A0 = A[0];
    bool Q0 = Q[0];

    for (int i = 0; i < A.size() - 1; ++i) {
        A[i] = A[i + 1];
        Q[i] = Q[i + 1];
    }
    A[A.size() - 1] = Q0;
    Q[Q.size() - 1] = A0;
    Q_1 = Q0;
}

// Función para realizar la suma binaria de dos números
void suma_binaria(vector<bool>& A, const vector<bool>& M) {
    bool acarreo = false;
    for (int i = A.size() - 1; i >= 0; --i) {
        bool A_bit = A[i];
        bool M_bit = M[i];

        A[i] = A_bit ^ M_bit ^ acarreo; // Suma XOR
        acarreo = (A_bit & M_bit) | (A_bit & acarreo) | (M_bit & acarreo); // Cálculo del acarreo
    }
}

// Función para realizar la resta complemento a 2 de dos números
void resta_complemento_dos(vector<bool>& A, const vector<bool>& M) {
    vector<bool> neg_M;
    for (bool bit : M) {
        neg_M.push_back(!bit); // Complemento a 1 de M
    }
    vector<bool> uno(A.size(), true); // Vector de unos del mismo tamaño que A
    suma_binaria(neg_M, uno); // Sumar 1 al complemento a 1 de M
    suma_binaria(A, neg_M); // Sumar M al número A
}

// Función para imprimir los valores de A y Q en consola
void imprimir_valores(const vector<bool>& A, const vector<bool>& Q) {
    cout << "A: ";
    for (bool bit : A) {
        cout << bit;
    }
    cout << endl;
    cout << "Q: ";
    for (bool bit : Q) {
        cout << bit;
    }
    cout << endl;
}

// Función principal que implementa el algoritmo de Booth
void multiplicacion_booth(const vector<bool>& M, const vector<bool>& Q) {
    vector<bool> A = M; // Inicializar A con el multiplicando M
    vector<bool> q = Q; // Inicializar Q con el multiplicador Q
    bool q_1 = false; // Inicializar Q_1 como falso

    cout << "Iteración 0:" << endl;
    imprimir_valores(A, Q);

    for (int i = 0; i < Q.size(); ++i) {
        cout << "Iteración " << i + 1 << ":" << endl;
        if (q[0] == 0 && q_1 == 1) { // Restar M de A si Q_1Q = 10
            resta_complemento_dos(A, M);
            cout << "Restar M de A:" << endl;
        }
        else if (q[0] == 1 && q_1 == 0) { // Sumar M a A si Q_1Q = 01
            suma_binaria(A, M);
            cout << "Sumar M a A:" << endl;
        }
        desplazamiento_aritmetico_derecha(A, q, q_1); // Desplazamiento aritmético hacia la derecha
        imprimir_valores(A, q);
    }
}

int main() {
    int multiplicando, multiplicador;
    cout << "Ingrese el multiplicando: ";
    cin >> multiplicando;
    cout << "Ingrese el multiplicador: ";
    cin >> multiplicador;

    // Calcular el número de bits necesario para representar el multiplicando y el multiplicador
    int n_bits = max(__builtin_clz(abs(multiplicando)), __builtin_clz(abs(multiplicador))) + 1;

    // Multiplicar los números con el tamaño de bits calculado
    multiplicacion_booth(vector<bool>(n_bits, multiplicando), vector<bool>(n_bits, multiplicador));

    return 0;
}
