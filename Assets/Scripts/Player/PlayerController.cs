using UnityEngine;

public class PlayerController : MonoBehaviour
{

    [Header("Basic config")]
    public float maxForce = 10f; // Fuerza m�xima que se puede aplicar
    public float minForce = 3.0f;
    public float maxSlideDistance = 3f; // Distancia m�xima de deslizamiento
    public float minimumRequiredSlideDistance = 0.25f;
    public LineRenderer lineRenderer; // Referencia al LineRenderer para la visualizaci�n de la direcci�n

    [Header("Modifiers")]
    public float fallMultiplier = 2.5f;

    private Vector2 initialPosition;
    private Vector2 finalPosition;
    private Rigidbody2D rb;
    private float shootForce;

    private void Start()
    {
        rb = GetComponent<Rigidbody2D>();
        lineRenderer.positionCount = 2;
        lineRenderer.enabled = false;
    }

    private void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            initialPosition = Camera.main.ScreenToWorldPoint(Input.mousePosition);
            lineRenderer.SetPosition(1, initialPosition);
            lineRenderer.SetPosition(0, initialPosition);
            lineRenderer.enabled = true;
        }
        else if (Input.GetMouseButton(0))
        {
            finalPosition = Camera.main.ScreenToWorldPoint(Input.mousePosition);

            // Limita la distancia m�xima de deslizamiento
            float distance = Vector2.Distance(initialPosition, finalPosition);
            float clampedDistance = Mathf.Clamp(distance, 0f, maxSlideDistance);

            // Escala la fuerza exponencialmente en funci�n de la distancia
            shootForce = Mathf.Pow(clampedDistance / maxSlideDistance, 2) * maxForce;
            shootForce = Mathf.Max(shootForce, minForce);

            // Ajusta la posici�n final del LineRenderer en funci�n de la distancia
            Vector2 adjustedFinalPosition = initialPosition + (finalPosition - initialPosition).normalized * clampedDistance;
            lineRenderer.SetPosition(1, adjustedFinalPosition);

            lineRenderer.enabled = distance >= minimumRequiredSlideDistance;
        }
        else if (Input.GetMouseButtonUp(0))
        {
            float distance = Vector2.Distance(initialPosition, finalPosition);

            if (distance >= minimumRequiredSlideDistance)
            {
                // Cambia la direcci�n al rev�s
                Vector2 direction = initialPosition - finalPosition;

                // Normaliza la direcci�n
                direction.Normalize();

                // Aplica la fuerza al objeto del jugador
                rb.AddForce(direction * shootForce, ForceMode2D.Impulse);
            }

            // Desactiva la visualizaci�n de la l�nea
            lineRenderer.enabled = false;
        }
    }

    private void FixedUpdate()
    {
        rb.velocity += (fallMultiplier - 1) * Physics2D.gravity.y * Time.deltaTime * Vector2.up;
    }
}
