using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// クリックまたはWASDでCubeを動かす
public class MoveCube : MonoBehaviour {

    [SerializeField]
    private LayerMask mask;

    [SerializeField]
    private float Speed = 2.0f;

    // Use this for initialization
    void Start() {

    }

    // Update is called once per frame
    void Update() {
        if ( Input.GetMouseButton( 0 ) ) {
            MoveClickPos( Input.mousePosition );
        }

        var dir = GetAxisRaw();
        transform.Translate( new Vector3( dir.x, dir.y, 0.0f ) * Speed * Time.deltaTime );
    }

    void MoveClickPos( Vector3 pos ) {
        Ray ray = Camera.main.ScreenPointToRay( pos );
        RaycastHit hit;
        if ( Physics.Raycast( ray, out hit, 100, mask ) ) {
            transform.position = hit.point;
        }
    }

    Vector2 GetAxisRaw() {
        return new Vector2( Input.GetAxisRaw( "Horizontal" ), Input.GetAxisRaw( "Vertical" ) );
    }
}
