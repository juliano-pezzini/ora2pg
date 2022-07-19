-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reverter_medic_quimio_onc (nr_seq_atendimento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_horario_p bigint, nr_agrupamento_p bigint) AS $body$
DECLARE

				
nr_seq_material_w	    bigint;	
ie_administrar_seq_w	varchar(1);	

C01 CURSOR FOR
	SELECT	nr_seq_material
	from 	paciente_atend_medic a
	where 	nr_seq_atendimento  = nr_seq_atendimento_p
	and	    ie_administracao    = 'A'
	and 	coalesce(nr_seq_diluicao::text, '') = '';


BEGIN

select	coalesce(max(Obter_Valor_Param_Usuario(3130, 61, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p)), 'S')
into STRICT	ie_administrar_seq_w
;

open C01;
loop
fetch C01 into	
	nr_seq_material_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (ie_administrar_seq_w = 'S') then
		CALL reverter_status_medic_quimio(nr_seq_atendimento_p,nr_agrupamento_p,nm_usuario_p,'A');
	else
		CALL reverter_status_medic_quimio(nr_seq_atendimento_p,nr_seq_material_w,nm_usuario_p,'M');
	end if;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reverter_medic_quimio_onc (nr_seq_atendimento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_horario_p bigint, nr_agrupamento_p bigint) FROM PUBLIC;

