-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_avaliacao_item ( nr_seq_item_pront_p bigint, nr_seq_tipo_avaliacao_p INOUT bigint, nr_atendimento_p bigint default 0) AS $body$
DECLARE

 
									 
cd_perfil_w		bigint:= coalesce(obter_perfil_ativo,0);									
nr_seq_tipo_avaliacao_w	bigint;	
cd_setor_atendimento_w	bigint	:= 0;
nr_agrupamento_w		bigint := 0;
nm_usuario_w			varchar(15);
									
									 
c01 CURSOR FOR 
	SELECT	nr_seq_tipo_avaliacao 
	from	regra_avaliacao_item 
	where	nr_seq_item_pront = nr_seq_item_pront_p	 
	and		coalesce(cd_perfil,cd_perfil_w) = cd_perfil_w 
	and		coalesce(cd_setor_atendimento,cd_setor_atendimento_w) = cd_setor_atendimento_w 
	and		coalesce(nr_seq_agrupamento,coalesce(Obter_agrup_setor(cd_setor_atendimento_w,'C'),'0'))	= coalesce(Obter_agrup_setor(cd_setor_atendimento_w,'C'),'0') 
	and		coalesce(nm_usuario_config,nm_usuario_w)		= nm_usuario_w	 
	order by coalesce(cd_perfil,0), 
			 coalesce(cd_setor_atendimento, 0), 
			 coalesce(nr_seq_agrupamento,Obter_agrup_setor(cd_setor_atendimento_w,'C')), 
			 coalesce(nm_usuario_config,nm_usuario_w);
			

BEGIN 
 
if (coalesce(nr_atendimento_p,0)	> 0) then 
	select	max(cd_setor_atendimento) 
	into STRICT	cd_setor_atendimento_w 
	from	resumo_atendimento_paciente_v 
	where	nr_atendimento	= nr_atendimento_p;
end if;
 
nm_usuario_w		:= coalesce(wheb_usuario_pck.get_nm_usuario,'AAAAAA');
 
open c01;
loop 
fetch c01 into	 
	nr_seq_tipo_avaliacao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
end loop;
close c01;
 
nr_seq_tipo_avaliacao_p	:= nr_seq_tipo_avaliacao_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_avaliacao_item ( nr_seq_item_pront_p bigint, nr_seq_tipo_avaliacao_p INOUT bigint, nr_atendimento_p bigint default 0) FROM PUBLIC;

