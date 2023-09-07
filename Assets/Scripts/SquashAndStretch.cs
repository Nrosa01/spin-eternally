using UnityEngine;

public class SquashAndStretch : MonoBehaviour
{
    Vector3 previousPosition;
    public float maxSpeedThreshold;
    public float minSpeedThreshold;
    public float maxStretch = 1.8f;

    float inverseStretch;
    private Transform parent;

    private void Start()
    {
        inverseStretch = 1 / Mathf.Sqrt(maxStretch);
        parent = transform.parent;
    }

    void Stretch()
    {
        Vector3 velocity = (transform.position - previousPosition) / Time.deltaTime;
        previousPosition = transform.position;
        
        float squashFactor = Mathf.Clamp01(velocity.magnitude / maxSpeedThreshold);
        parent.localScale = Vector3.Lerp(Vector3.one, new Vector3(inverseStretch, maxStretch, inverseStretch), squashFactor);
        parent.rotation = Quaternion.LookRotation(Vector3.forward, velocity.normalized);
    }

    private void Update()
    {
        Stretch();
    }
}
