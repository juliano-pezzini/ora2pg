-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_copia_verif_intera_med ( nr_seq_mat_cpoe_p bigint, nr_atendimento_p bigint, cd_perfil_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
cd_paciente_w			atendimento_paciente.cd_pessoa_fisica%type;
cd_material_w			cpoe_material_vig_v.cd_material%type;
ie_funcao_prescritor_w	usuario.ie_tipo_evolucao%type;
ds_orientacao_w			varchar(4000);
ds_interacao_w			varchar(4000);
						
c01 CURSOR FOR 
SELECT	cd_material 
from	cpoe_material_vig_v 
where	nr_sequencia = nr_seq_mat_cpoe_p 
and		nr_atendimento = nr_atendimento_p;	
 

BEGIN 
 
select	max(cd_pessoa_fisica) 
into STRICT	cd_paciente_w 
from	atendimento_paciente 
where	nr_atendimento = nr_atendimento_p;
 
select	max(ie_tipo_evolucao) 
into STRICT	ie_funcao_prescritor_w 
from	usuario 
where	nm_usuario = nm_usuario_p;
 
open c01;
loop 
fetch c01 into	cd_material_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	SELECT * FROM cpoe_verificar_interacao_medic(nr_seq_mat_cpoe_p, nr_atendimento_p, cd_material_w, cd_perfil_p, cd_estabelecimento_p, cd_paciente_w, ie_funcao_prescritor_w, nm_usuario_p, ds_orientacao_w, ds_interacao_w) INTO STRICT ds_orientacao_w, ds_interacao_w;
	end;
end loop;
close c01;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_copia_verif_intera_med ( nr_seq_mat_cpoe_p bigint, nr_atendimento_p bigint, cd_perfil_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
