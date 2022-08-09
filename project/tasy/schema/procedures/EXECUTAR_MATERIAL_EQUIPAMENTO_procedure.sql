-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE executar_material_equipamento ( nr_cirurgia_p bigint, cd_local_estoque_p bigint default null, nm_usuario_p text  DEFAULT NULL) AS $body$
DECLARE

cd_material_w		integer;
qt_material_w 		double precision;
nr_atendimento_w	bigint;			
nr_sequencia_w		bigint;
cd_convenio_w		integer;
cd_categoria_w		varchar(10);
ie_baixa_estoque_w	varchar(15);
cd_local_estoque_w	smallint;
											
c01 CURSOR FOR 
	SELECT	a.nr_sequencia, 
		a.cd_material, 
		a.qt_material, 
		c.nr_atendimento, 
		b.cd_convenio, 
		b.cd_categoria 
	from 	material_equip_cirurgia a, 
		equipamento_cirurgia b, 
		cirurgia c 
	where	a.nr_seq_equi_cir	= b.nr_sequencia 
	and	b.nr_cirurgia 	= c.nr_cirurgia 
	and	b.nr_cirurgia 	= nr_cirurgia_p 
	and	coalesce(b.ie_situacao,'A') = 'A' 
	and	coalesce(a.dt_lancamento_automatico::text, '') = '';
	

BEGIN 
 
ie_baixa_estoque_w := Obter_Param_Usuario(872, 481, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_baixa_estoque_w);
 
cd_local_estoque_w	:= null;
if (ie_baixa_estoque_w = 'S') then 
	cd_local_estoque_w := cd_local_estoque_p;
end if;
 
open C01;
loop 
fetch C01 into 
	nr_sequencia_w, 
	cd_material_w, 
	qt_material_w, 
	nr_atendimento_w, 
	cd_convenio_w, 
	cd_categoria_w;				
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
		 
	CALL gerar_lancto_automatico_conta(	nr_atendimento_w, 
					nr_cirurgia_p, 
					cd_material_w, 
					qt_material_w, 
					cd_local_estoque_w, 
					null, 
					null, 
					null, 
					null, 
					nm_usuario_p, 
					cd_convenio_w, 
					cd_categoria_w, 
					null);
					 
	update	material_equip_cirurgia 
	set		dt_lancamento_automatico	=	clock_timestamp() 
	where	nr_sequencia			=	nr_sequencia_w;
	commit;
	end;
end loop;
close C01;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE executar_material_equipamento ( nr_cirurgia_p bigint, cd_local_estoque_p bigint default null, nm_usuario_p text  DEFAULT NULL) FROM PUBLIC;
