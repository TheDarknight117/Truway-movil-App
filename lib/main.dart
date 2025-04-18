import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Asegúrate de tener el import correcto

void main() {
  runApp(const TruwayApp());
}

class TruwayApp extends StatelessWidget {
  const TruwayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Conductores - Truway',
      theme: ThemeData(primarySwatch: Colors.teal, useMaterial3: true),
      home: const RegistroConductor(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RegistroConductor extends StatefulWidget {
  const RegistroConductor({super.key});

  @override
  State<RegistroConductor> createState() => _RegistroConductorState();
}

class _RegistroConductorState extends State<RegistroConductor> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nombresController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController ciController = TextEditingController();
  final TextEditingController placaController = TextEditingController();
  final TextEditingController celularController = TextEditingController();

  void _registrarConductor() {
    if (_formKey.currentState!.validate()) {
      // Codificar los datos del conductor en un Map
      final conductorData = {
        'nombres': nombresController.text,
        'apellidos': apellidosController.text,
        'ci': ciController.text,
        'placa': placaController.text,
        'celular': celularController.text,
      };

      // Navegar a la pantalla con el QR generado
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MostrarQR(conductorData: conductorData),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Conductor'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(nombresController, "Nombres"),
              const SizedBox(height: 10),
              _buildTextField(apellidosController, "Apellidos"),
              const SizedBox(height: 10),
              _buildTextField(ciController, "CI", tipo: TextInputType.number),
              const SizedBox(height: 10),
              _buildTextField(placaController, "Placa del vehículo"),
              const SizedBox(height: 10),
              _buildTextField(
                celularController,
                "Número de celular",
                tipo: TextInputType.phone,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _registrarConductor,
                child: const Text("REGISTRAR"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType tipo = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: tipo,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator:
          (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
    );
  }
}

class MostrarQR extends StatelessWidget {
  final Map<String, String> conductorData;

  const MostrarQR({super.key, required this.conductorData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido a TRUWAY'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Generar el QR con los datos
            QrImageView(
              data: conductorData.toString(),
              version: QrVersions.auto,
              size: 200.0,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Colors.black,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Conductor: ${conductorData['nombres']} ${conductorData['apellidos']}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Placa: ${conductorData['placa']}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
