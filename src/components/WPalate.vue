<template>
  <div ref="canvas-container" v-resize="onResize">
    <canvas ref="canvas"></canvas>
  </div>
</template>

<script>
import * as THREE from "three";
import OBJLoader from "three-obj-loader";
import OBJExporter from "three-obj-exporter";
OBJLoader(THREE);

export default {
  name: "w-palate",
  data() {
    const scene = new THREE.Scene();
    const renderer = null;
    const camera = new THREE.PerspectiveCamera(
      50,
      window.innerWidth / window.innerHeight,
      0.1,
      2000
    );
    const light = new THREE.DirectionalLight(0xffffff);
    const geometry = new THREE.BoxGeometry(1, 1, 1);
    const material = new THREE.MeshNormalMaterial();
    const cube = new THREE.Mesh(geometry, material);
    const obj = null;
    const cameraRoutation = {
      x: 0,
      y: 0,
    };
    const objRoutation = {
      x: 0,
      y: 0,
      z: 0,
    };
    return {
      obj,
      scene,
      renderer,
      camera,
      light,
      geometry,
      material,
      cube,
      cameraRoutation,
      objRoutation,
    };
  },
  props: {
    src: {
      type: String,
      require: true,
    },
    aspect: {
      type: Number,
      default: 1,
    },
    cameraPosition: {
      type: Number,
      default: 200,
    },
  },
  watch: {
    src: function (val, old_val) {
      if (val != old_val) this.loadObj(val);
    },
    cameraPosition: function (val, old_val) {
      if (val) {
        if (val != old_val) this.updateCPositionZ(val);
      }
    },
  },
  methods: {
    onResize: function () {
      this.$nextTick(() => {
        const container = this.$refs["canvas-container"];
        const canvas = this.$refs.canvas;
        canvas.width = container.clientWidth;
        canvas.height = container.clientWidth / this.aspect;
        this.renderer.setPixelRatio(window.devicePixelRatio);
        this.renderer.setSize(
          container.clientWidth,
          container.clientWidth / this.aspect
        );
        this.camera.aspect = this.aspect;
        this.camera.updateProjectionMatrix();
      });
    },
    loadObj: function (obj_path) {
      const vm = this;
      this.$nextTick(() => {
        const loader = new THREE.OBJLoader();
        loader.load(obj_path, function (res) {
          if (vm.obj != null) {
            vm.obj = null;
            vm.scene.remove(vm.obj);
          }
          vm.obj = res;
          vm.scene.add(vm.obj);
          vm.renderer.render(vm.scene, vm.camera);
        });
      });
    },
    saveObj: function () {
      const exporter = new OBJExporter();
      const objData = exporter.parse(this.obj);
      const blob = new Blob([objData], { type: "application/x-tgif" });
      const elm = document.createElement("a");
      elm.href = window.URL.createObjectURL(blob);
      elm.download = "result.obj";
      elm.click();
    },
    updateORotX: function (rot) {
      const radian = (rot * Math.PI) / 180;
      this.obj.rotation.x = radian;
      this.renderer.render(this.scene, this.camera);
    },
    updateORotY: function (rot) {
      const radian = (rot * Math.PI) / 180;
      this.obj.rotation.y = radian;
      this.renderer.render(this.scene, this.camera);
    },
    updateORotZ: function (rot) {
      const radian = (rot * Math.PI) / 180;
      this.obj.rotation.z = radian;
      this.renderer.render(this.scene, this.camera);
    },
    updateCRotX: function (rot) {
      const radian = (rot * Math.PI) / 180;
      this.camera.position.x = this.cameraPosition * Math.sin(radian);
      this.camera.position.z = this.cameraPosition * Math.cos(radian);
      this.camera.lookAt(new THREE.Vector3(0, 0, 0));
      this.renderer.render(this.scene, this.camera);
    },
    updateCRotY: function (rot) {
      const radian = (rot * Math.PI) / 180;
      this.camera.position.y = this.cameraPosition * Math.sin(radian);
      this.camera.position.z = this.cameraPosition * Math.cos(radian);
      this.camera.lookAt(new THREE.Vector3(0, 0, 0));
      this.renderer.render(this.scene, this.camera);
    },
    updateCPositionZ: function (position) {
      this.camera.position.set(0, 0, position);
      this.renderer.render(this.scene, this.camera);
    },
    incOX: function () {
      this.obj.translateX(1);
      this.renderer.render(this.scene, this.camera);
    },
    decOX: function () {
      this.obj.translateX(-1);
      this.renderer.render(this.scene, this.camera);
    },
    incOY: function () {
      this.obj.translateY(1);
      this.renderer.render(this.scene, this.camera);
    },
    decOY: function () {
      this.obj.translateY(-1);
      this.renderer.render(this.scene, this.camera);
    },
    incOZ: function () {
      this.obj.translateZ(1);
      this.renderer.render(this.scene, this.camera);
    },
    decOZ: function () {
      this.obj.translateZ(-1);
      this.renderer.render(this.scene, this.camera);
    },
    incORotX: function () {
      this.objRoutation.x += 1;
      this.updateORotX(this.objRoutation.x);
    },
    decORotX: function () {
      this.objRoutation.x -= 1;
      this.updateORotX(this.objRoutation.x);
    },
    incORotY: function () {
      this.objRoutation.y += 1;
      this.updateORotY(this.objRoutation.y);
    },
    decORotY: function () {
      this.objRoutation.y -= 1;
      this.updateORotY(this.objRoutation.y);
    },
    incORotZ: function () {
      this.objRoutation.z += 1;
      this.updateORotZ(this.objRoutation.z);
    },
    decORotZ: function () {
      this.objRoutation.z -= 1;
      this.updateORotZ(this.objRoutation.z);
    },
    incCRotX: function () {
      this.cameraRoutation.x += 1;
      this.updateCRotX(this.cameraRoutation.x);
    },
    decCRotX: function () {
      this.cameraRoutation.x -= 1;
      this.updateCRotX(this.cameraRoutation.x);
    },
    incCRotY: function () {
      this.cameraRoutation.y += 1;
      this.updateCRotY(this.cameraRoutation.y);
    },
    decCRotY: function () {
      this.cameraRoutation.y -= 1;
      this.updateCRotY(this.cameraRoutation.y);
    },
  },
  mounted() {
    this.onResize();
    const canvas = this.$refs.canvas;
    this.renderer = new THREE.WebGLRenderer({
      antialias: true,
      canvas: canvas,
    });
    // 地面を作成
    if (this.scene) {
      const plane2 = new THREE.GridHelper(600);
      const plane = new THREE.AxesHelper(300);
      this.scene.add(plane);
      this.scene.add(plane2);
    }
    // カメラ, 光源, シーンの追加
    this.camera.position.set(0, 0, this.cameraPosition);
    this.light.position.set(0, 0, 10);
    this.scene.add(this.light);
    this.renderer.render(this.scene, this.camera);

    // シーンにオブジェクトを表示
    this.loadObj(this.src);
  },
};
</script>
<style>
body {
  margin: 0;
  overflow: hidden;
}
</style>
