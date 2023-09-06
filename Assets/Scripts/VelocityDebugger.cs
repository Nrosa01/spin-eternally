using UnityEngine;

public class VelocityDebugger : MonoBehaviour
{
    public Vector2 velocity; // Variable pública para ver la velocidad en el inspector
    private Vector3 lastPosition; // Almacena la posición anterior para calcular la velocidad

    private void Start()
    {
        lastPosition = transform.position;
    }

    private void Update()
    {
        // Calcula la velocidad en 2D
        Vector3 currentPosition = transform.position;
        Vector3 displacement = currentPosition - lastPosition;

        // Divide el desplazamiento por el tiempo transcurrido para obtener la velocidad
        float deltaTime = Time.deltaTime;
        velocity = new Vector2(displacement.x / deltaTime, displacement.y / deltaTime);

        // Actualiza la posición anterior para el siguiente frame
        lastPosition = currentPosition;
    }
}
