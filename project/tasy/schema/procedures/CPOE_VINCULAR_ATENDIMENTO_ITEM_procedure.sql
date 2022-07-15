-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_vincular_atendimento_item ( nr_sequencia_p cpoe_dieta.nr_sequencia%type, ie_tipo_item_p text, nr_atendimento_p atendimento_paciente.nr_atendimento%type, nm_usuario_p usuario.nm_usuario%type ) AS $body$
BEGIN

	case
		when ie_tipo_item_p = 'MAT' then -- Material
		begin
			update	cpoe_material
			set		nr_atendimento = nr_atendimento_p,
					nm_usuario = nm_usuario_p
			where	nr_sequencia = nr_sequencia_p;
		end;
		when ie_tipo_item_p = 'M' or ie_tipo_item_p = 'SOL' then -- Medicine
		begin
			update	cpoe_material
			set		nr_atendimento = nr_atendimento_p,
					nm_usuario = nm_usuario_p
			where	nr_sequencia = nr_sequencia_p;
		end;
		when ie_tipo_item_p = 'D' or ie_tipo_item_p = 'SNE'
			or ie_tipo_item_p = 'S' or ie_tipo_item_p = 'J'
			or ie_tipo_item_p = 'LD' or ie_tipo_item_p = 'NPTA'
			or ie_tipo_item_p = 'NPTI' then -- Nutrition
		begin
			update	cpoe_dieta
			set		nr_atendimento = nr_atendimento_p,
					nm_usuario = nm_usuario_p
			where	nr_sequencia = nr_sequencia_p;
		end;
		when ie_tipo_item_p = 'P' then -- Procedure
		begin
			update	cpoe_procedimento
			set		nr_atendimento = nr_atendimento_p,
					nm_usuario = nm_usuario_p
			where	nr_sequencia = nr_sequencia_p;
		end;
		when ie_tipo_item_p = 'O' then -- Gasotherapy
		begin
			update	cpoe_gasoterapia
			set		nr_atendimento = nr_atendimento_p,
					nm_usuario = nm_usuario_p
			where	nr_sequencia = nr_sequencia_p;
		end;
		when ie_tipo_item_p = 'R' then -- Recommendation
		begin
			update	cpoe_recomendacao
			set		nr_atendimento = nr_atendimento_p,
					nm_usuario = nm_usuario_p
			where	nr_sequencia = nr_sequencia_p;
		end;
		when ie_tipo_item_p = 'HM' then -- Hemotherapy
		begin
			update	cpoe_hemoterapia
			set		nr_atendimento = nr_atendimento_p,
					nm_usuario = nm_usuario_p
			where	nr_sequencia = nr_sequencia_p;
		end;
		when ie_tipo_item_p = 'DI' then -- Dialysis
		begin
			update	cpoe_dialise
			set		nr_atendimento = nr_atendimento_p,
					nm_usuario = nm_usuario_p
			where	nr_sequencia = nr_sequencia_p;
		end;
		when ie_tipo_item_p = 'AP' then -- Anatomical Pathology
		begin
			update	cpoe_anatomia_patologica
			set		nr_atendimento = nr_atendimento_p,
					nm_usuario = nm_usuario_p
			where	nr_sequencia = nr_sequencia_p;
		end;
	end case;

	commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_vincular_atendimento_item ( nr_sequencia_p cpoe_dieta.nr_sequencia%type, ie_tipo_item_p text, nr_atendimento_p atendimento_paciente.nr_atendimento%type, nm_usuario_p usuario.nm_usuario%type ) FROM PUBLIC;

