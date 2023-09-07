using UnityEngine;

public class SquashAndStretch : MonoBehaviour
{
    public Transform cube;
    public Transform parent;
    Vector3 previousPosition;
    public float maxSpeed;
    public float maxStretch = 1.8f;

    float inverseStretch;

    private void Start()
    {
        inverseStretch = 1 / Mathf.Sqrt(maxStretch);
    }

    void Stretch()
    {
        Vector3 velocity = (cube.position - previousPosition) / Time.deltaTime;
        float squashFactor = Mathf.Clamp01(velocity.magnitude / maxSpeed);
        parent.localScale = Vector3.Lerp(Vector3.one, new Vector3(inverseStretch, maxStretch, inverseStretch), squashFactor);
        previousPosition = cube.position;
        parent.rotation = Quaternion.LookRotation(Vector3.forward, velocity.normalized);
    }

    private void Update()
    {
        Stretch();
    }
}
