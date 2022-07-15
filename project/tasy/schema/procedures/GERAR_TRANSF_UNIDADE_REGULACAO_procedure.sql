-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_transf_unidade_regulacao (nr_seq_unidade_p bigint, nr_atendimento_p bigint, nr_seq_regulacao_p bigint, nm_usuario_p text) AS $body$
DECLARE

		 
nr_seq_regra_w		bigint;
qt_existe_w		bigint;
cd_setor_atendimento_w	integer;
cd_tipo_acomodacao_w	smallint;
cd_unidade_basica_w	varchar(10);
cd_unidade_compl_w   varchar(10);

		 

BEGIN 
 
select	count(*) 
into STRICT	qt_existe_w 
from 	eme_reg_resposta 
where 	nr_seq_reg 	= nr_seq_regulacao_p 
and	nr_seq_unidade 	= nr_seq_unidade_p;
 
select	max(nr_sequencia) 
into STRICT	nr_seq_regra_w 
from	eme_regra_gerar_atend_set 
where	nr_seq_unidade = nr_seq_unidade_p;
 
if (qt_existe_w = 0) and (nr_seq_regra_w > 0) and (nr_atendimento_p > 0)then 
	--REGRA DE GERAÇÃO DE ATENDIMENTO 
	select	max(cd_setor_atendimento), 
		max(cd_tipo_acomodacao), 
		max(cd_unidade_basica), 
		max(cd_unidade_compl) 
	into STRICT	cd_setor_atendimento_w, 
		cd_tipo_acomodacao_w, 
		cd_unidade_basica_w, 
		cd_unidade_compl_w 
	from	eme_regra_gerar_atend_set 
	where	nr_sequencia	= nr_seq_regra_w;
	-- GERAR TRANSFERÊNCIA DO PACIENTE 
	 
	update	atend_paciente_unidade 
	set	dt_saida_unidade = clock_timestamp() 
	where	nr_atendimento = nr_atendimento_p 
	and	coalesce(dt_saida_unidade::text, '') = '';
	 
	CALL Gerar_Transferencia_Paciente(nr_atendimento_p, 
				   cd_setor_atendimento_w, 
				   cd_unidade_basica_w, 
				   cd_unidade_compl_w, 
				   cd_tipo_acomodacao_w, 
				   0, 
				   null, 
				   null, 
				   nm_usuario_p, 
				   clock_timestamp());
end if;
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_transf_unidade_regulacao (nr_seq_unidade_p bigint, nr_atendimento_p bigint, nr_seq_regulacao_p bigint, nm_usuario_p text) FROM PUBLIC;

