-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_itens_conta_evol ( cd_evolucao_P bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_sequencia_w			bigint;
ie_tipo_w				varchar(10);
nr_interno_conta_w		bigint;
cd_motivo_exc_conta_w	bigint;
cd_estabelecimento_w	bigint;
nr_seq_proc_pacote_w	bigint;
nr_atendimento_w		bigint;

c02 CURSOR FOR 
	SELECT	'P' ie_tipo, 
		a.nr_sequencia, 
		a.nr_interno_conta, 
		a.nr_seq_proc_pacote 
	from	procedimento_paciente a, 
		conta_paciente b, 
		regra_lanc_automatico c 
	where	a.nr_interno_conta 	= b.nr_interno_conta 
	and	b.nr_Atendimento	= nr_atendimento_w 
	and	c.nr_sequencia		= a.nr_seq_regra_lanc 
	and	b.ie_status_acerto	= 1 
	and	c.NR_SEQ_EVENTO		= 123 
	and	a.ds_observacao like '%'||CD_EVOLUCAO_P||'%' 
	and	coalesce(a.cd_motivo_exc_conta::text, '') = '' 
	
union all
 
	SELECT	'M' ie_tipo, 
		a.nr_sequencia, 
		a.nr_interno_conta, 
		a.nr_seq_proc_pacote 
	from	material_Atend_paciente a, 
		conta_paciente b, 
		regra_lanc_automatico c 
	where	a.nr_interno_conta 	= b.nr_interno_conta 
	and	b.nr_Atendimento	= nr_atendimento_w 
	and	c.nr_sequencia		= a.nr_seq_regra_lanc 
	and	b.ie_status_acerto	= 1 
	and	c.NR_SEQ_EVENTO		= 123 
	and	a.ds_observacao like '%'||CD_EVOLUCAO_P||'%' 
	and	coalesce(a.cd_motivo_exc_conta::text, '') = '';
	
	 
 

BEGIN 
select	max(nr_atendimento) 
into STRICT	nr_atendimento_w 
from	evolucao_paciente 
where	cd_evolucao = cd_evolucao_p;
 
select	max(cd_estabelecimento) 
into STRICT	cd_estabelecimento_w 
from	atendimento_paciente 
where	nr_atendimento	= nr_atendimento_w;
 
select	max(cd_motivo_exc_conta) 
into STRICT	cd_motivo_exc_conta_w 
from	parametro_faturamento 
where	cd_estabelecimento	= cd_estabelecimento_w;
 
open C02;
loop 
fetch C02 into	 
	ie_tipo_w, 
	nr_sequencia_w, 
	nr_interno_conta_w, 
	nr_seq_proc_pacote_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin 
	 
	CALL excluir_matproc_conta(nr_sequencia_w,nr_interno_conta_w,cd_motivo_exc_conta_w,obter_desc_expressao(324941),ie_tipo_w,nm_usuario_p);
	end;
end loop;
close C02;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_itens_conta_evol ( cd_evolucao_P bigint, nm_usuario_p text) FROM PUBLIC;
