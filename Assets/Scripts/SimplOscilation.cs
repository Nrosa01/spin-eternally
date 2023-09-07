using UnityEngine;

public class SimpleOscilacion : MonoBehaviour
{
    public Vector3 direction = Vector3.up.normalized; // Direcci�n normalizada del movimiento oscilante
    public float speed = 1.0f; // Velocidad de oscilaci�n
    public float distance = 1.0f; // Distancia m�xima de oscilaci�n

    private Vector3 initialPosition;

    private void Start()
    {
        initialPosition = transform.position;
    }

    private void Update()
    {
        // Calcula el desplazamiento en funci�n del tiempo, direcci�n y distancia.
        float displacement = Mathf.Sin(Time.time * speed) * distance;

        // Aplica el desplazamiento a la posici�n actual del objeto.
        transform.position = initialPosition + direction.normalized * displacement;
    }

    private void OnValidate()
    {
        direction.Normalize();
    }

    // Dibuja gizmos para visualizar la direcci�n configurada.
    private void OnDrawGizmos()
    {
        Gizmos.color = Color.yellow;
        Vector3 pos = initialPosition;
        if (pos == Vector3.zero)
            pos = transform.position;

        Gizmos.DrawLine(pos , pos + direction.normalized * distance);
        Gizmos.DrawLine(pos , pos - direction.normalized * distance);
    }
}
