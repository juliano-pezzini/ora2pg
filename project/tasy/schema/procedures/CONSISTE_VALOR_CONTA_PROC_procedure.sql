-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_valor_conta_proc ( nr_interno_conta_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE



ds_erro_w		varchar(80) 	:= '';
cd_convenio_w		integer;
ie_tipo_atend_w		smallint;
cd_estab_w		integer;
ie_regra_w		varchar(01);

cd_area_w		bigint;
cd_especialidade_w	bigint;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
cd_grupo_w		bigint;
cd_categoria_w		varchar(10);
cd_setor_atendimento_w	integer;
nr_seq_proc_interno_w	bigint;
nr_seq_exame_w		bigint;
ie_tipo_atend_conta_w	smallint;
nr_seq_proc_pacote_w	bigint;
nr_sequencia_w		bigint;
ie_responsavel_credito_w	procedimento_paciente.ie_responsavel_credito%type;

C01 CURSOR FOR
SELECT	cd_procedimento,
	ie_origem_proced,
	cd_setor_atendimento,
	nr_seq_proc_interno,
	nr_seq_exame,
	nr_seq_proc_pacote,
	nr_sequencia,
	ie_responsavel_credito
from	procedimento_paciente
where	nr_interno_conta 	= nr_interno_conta_p
and	coalesce(cd_motivo_exc_conta::text, '') = ''
and	coalesce(vl_procedimento,0)	= 0;


C02 CURSOR FOR
SELECT	ie_regra
from 	regra_valor_conta
where	cd_estabelecimento      			= cd_estab_w
and	coalesce(cd_procedimento, cd_procedimento_w)		= cd_procedimento_w
and	coalesce(cd_grupo_proc, cd_grupo_w)			= cd_grupo_w
and	coalesce(cd_especialidade_proc, cd_especialidade_w)	= cd_especialidade_w
and	coalesce(cd_area_procedimento, cd_area_w)		= cd_area_w
and	coalesce(cd_convenio, cd_convenio_w)			= cd_convenio_w
and 	coalesce(ie_tipo_atendimento,ie_tipo_atend_w)	= ie_tipo_atend_w
and 	coalesce(ie_tipo_atend_conta,ie_tipo_atend_conta_w)	= ie_tipo_atend_conta_w
and	coalesce(cd_categoria, cd_categoria_w)		= cd_categoria_w
and 	coalesce(cd_setor_atendimento, coalesce(cd_setor_atendimento_w,0)) = coalesce(cd_setor_atendimento_w,0)
and	coalesce(nr_seq_proc_interno, coalesce(nr_seq_proc_interno_w,0))	= coalesce(nr_seq_proc_interno_w,0)
and	coalesce(nr_seq_exame, coalesce(nr_seq_exame_w,0))	= coalesce(nr_seq_exame_w,0)
and	coalesce(ie_responsavel_credito, coalesce(ie_responsavel_credito_w,0)) = coalesce(ie_responsavel_credito_w,0)

and	((cd_procedimento IS NOT NULL AND cd_procedimento::text <> '') or (cd_grupo_proc IS NOT NULL AND cd_grupo_proc::text <> '') or (cd_especialidade_proc IS NOT NULL AND cd_especialidade_proc::text <> '') or (cd_area_procedimento IS NOT NULL AND cd_area_procedimento::text <> '') or (nr_seq_proc_interno IS NOT NULL AND nr_seq_proc_interno::text <> '') or (nr_seq_exame IS NOT NULL AND nr_seq_exame::text <> '') or (ie_responsavel_credito IS NOT NULL AND ie_responsavel_credito::text <> ''))
order by
	coalesce(nr_seq_exame,0),
	coalesce(nr_seq_proc_interno,0),
	coalesce(cd_procedimento,0),
	coalesce(cd_grupo_proc,0),
	coalesce(cd_especialidade_proc,0),
	coalesce(cd_area_procedimento,0),
	coalesce(ie_tipo_atendimento,0),
	coalesce(ie_tipo_atend_conta,0),
	coalesce(cd_convenio,0),
	coalesce(cd_setor_atendimento,0),
	coalesce(ie_responsavel_credito,0);


BEGIN
ds_erro_w		:= '';
select	b.ie_tipo_atendimento,
	a.cd_convenio_parametro,
	b.cd_estabelecimento,
	a.cd_categoria_parametro,
	coalesce(a.ie_tipo_atend_conta,0)
into STRICT	ie_tipo_atend_w,
	cd_convenio_w,
	cd_estab_w,
	cd_categoria_w,
	ie_tipo_atend_conta_w
from	Atendimento_paciente b,
	conta_paciente a
where	a.nr_interno_conta	= nr_interno_conta_p
and	a.nr_atendimento	= b.nr_atendimento;

OPEN C01;
LOOP
FETCH C01 	into
		cd_procedimento_w,
		ie_origem_proced_w,
		cd_setor_atendimento_w,
		nr_seq_proc_interno_w,
		nr_seq_exame_w,
		nr_seq_proc_pacote_w,
		nr_sequencia_w,
		ie_responsavel_credito_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	ie_regra_w		:= 'I';

	if (cd_procedimento_w > 0) then
		select	cd_grupo_proc,
			cd_area_procedimento,
			cd_especialidade
		into STRICT	cd_grupo_w,
			cd_area_w,
			cd_especialidade_w
		from	estrutura_procedimento_v
		where	cd_procedimento		= cd_procedimento_w
		and	ie_origem_proced	= ie_origem_proced_w;

		OPEN C02;
		LOOP
		FETCH C02 into ie_regra_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			ie_regra_w	:= ie_regra_w;
		END LOOP;
		CLOSE C02;

		if (ie_regra_w = 'P') and (coalesce(nr_seq_proc_pacote_w,0) > 0) then
			ie_regra_w:= 'Z';  --Itens do Pacote pode ter valor zerado
		elsif (ie_regra_w	= 'D') and (Obter_Desconto_item_conta(nr_sequencia_w,1) <> 0) then
			ie_regra_w:= 'Z';  --Itens com desconto pode ter valor zerado
		end if;

	end if;

	if (ie_regra_w <> 'Z') then
		ds_erro_w	:= '3002 ';
	end if;

	end;
END LOOP;
CLOSE C01;

ds_erro_p		:= ds_erro_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_valor_conta_proc ( nr_interno_conta_p bigint, ds_erro_p INOUT text) FROM PUBLIC;
