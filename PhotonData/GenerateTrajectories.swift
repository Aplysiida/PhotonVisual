//
//  PhotonTrajectoryGenerator.swift
//  RenderPipeline
//
//  Created by robertvict on 29/05/23.
//

import Foundation

struct RNGWithSeed : RandomNumberGenerator {
    init(seed: Int) {
        srand48(seed)
    }
    
    func next() -> UInt64 {
        return UInt64(drand48() * Double(UInt64.max));
    }
}

let seed = 101
var rng = RNGWithSeed(seed: seed)
let alpha_rand: Float = 0.5    //used to vary x and y in photon trajectory

struct BoundingBox {
    var top_left: SIMD3<Float> = SIMD3<Float>(0.0, 0.0, 0.0)
    var width: Float = 1.0
    var height: Float = 1.0
    var depth: Float = 10.0
}

let bounding_box_info = BoundingBox()

/*
 Generate a trajactory for a photon
 */
func GenerateTrajectory(_ trajectory_size: Int) -> [SIMD3<Float>] {
    let rand_float = {(min: Float, max: Float) -> Float in return Float.random(in: min...max, using: &rng)}
    
    //let photon_trajectory: [SIMD3<Float>] = (0..<trajectory_size).map { _ in SIMD3<Float>.random(in: 1...20, using: &rng) }
    var photon_trajectory: [SIMD3<Float>] = (0..<trajectory_size).map { _ in SIMD3<Float>(0.0, 0.0, 0.0)}
    //first point, generate at any xy position at beginning
    photon_trajectory[0] = SIMD3<Float>(
        rand_float(bounding_box_info.top_left.x, bounding_box_info.top_left.x+bounding_box_info.width),
        rand_float(bounding_box_info.top_left.y-bounding_box_info.height, bounding_box_info.top_left.y),
        bounding_box_info.top_left.z
    );
    for i in 1..<trajectory_size {
        let new_point = SIMD3<Float>(
            photon_trajectory[i-1].x + rand_float(-alpha_rand, alpha_rand),
            photon_trajectory[i-1].y + rand_float(-alpha_rand, alpha_rand),
            photon_trajectory[i-1].z + bounding_box_info.depth/Float(trajectory_size)   //assume equal spacing in depth for now
        );
        photon_trajectory[i] = new_point;
    }
    return photon_trajectory
}

/*
 Generate list of photons, all of which have the same trajectory size
 */
func GeneratePhotons(_ photon_num: Int, _ trajectory_size: Int, _ photons: inout[[SIMD3<Float>]]) {
    photons = (0..<photon_num).map {_ in GenerateTrajectory(trajectory_size)}
}

func WritePhotonsToFile(_ photons: inout[[SIMD3<Float>]]) {
    //convert to string
    let photons_string = photons.reduce("",
        {prev_traj, curr_traj in
        prev_traj + curr_traj.reduce("", {
                prev, curr in
                prev + "\(curr.x) \(curr.y) \(curr.z), "
        }).dropLast().dropLast() + "\n" //two droplast to get rid of the ", "
    })
    //write to file PhotonData.txt at directory where program is run
    let filepath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath+"/PhotonData.txt")
    print("Writing to \(filepath)")
    do{
        try photons_string.write(to: filepath, atomically: true, encoding: .ascii)
    } catch {
        assertionFailure("Failed to write to URL: \(filepath)")
    }
}

func WriteBoundingBoxToFile() {
    //convert to string
    let bounding_box_string = "\(bounding_box_info.top_left.x) \(bounding_box_info.top_left.y) \(bounding_box_info.top_left.z)\n\(bounding_box_info.width)\n\(bounding_box_info.height)\n\(bounding_box_info.depth)"
    let filepath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath+"/BoundingBox.txt");
    print("Writing to \(filepath)")
    do {
        try bounding_box_string.write(to: filepath, atomically: true, encoding: .ascii)
    } catch {
        assertionFailure("Failed to write to URL: \(filepath)")
    }
}

//main
WriteBoundingBoxToFile()

let args = CommandLine.arguments
let photon_num: Int = Int(args[1]) ?? 0
let trajectory_num: Int = Int(args[2]) ?? 0
var photons = [[SIMD3<Float>]]()

GeneratePhotons(photon_num, trajectory_num, &photons)
WritePhotonsToFile(&photons)
