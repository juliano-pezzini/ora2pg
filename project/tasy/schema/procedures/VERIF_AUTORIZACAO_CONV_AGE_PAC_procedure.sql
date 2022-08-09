-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function verif_autorizacao_conv_age_pac as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE verif_autorizacao_conv_age_pac (nr_atendimento_p bigint, cd_convenio_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, ie_tipo_atendimento_p bigint, cd_plano_p text, cd_setor_atendimento_p bigint, cd_categoria_p text, cd_estabelecimento_p bigint, nr_sequencia_p bigint, cd_medico_p text, cd_pessoa_fisica_p text, ie_autorizacao_p INOUT text, ie_regra_p INOUT bigint, ds_erro_p INOUT text, cd_tipo_acomodacao_p bigint, cd_usuario_convenio_p text, ie_carater_cirurgia_p text) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'SELECT * FROM verif_autorizacao_conv_age_pac_atx ( ' || quote_nullable(nr_atendimento_p) || ',' || quote_nullable(cd_convenio_p) || ',' || quote_nullable(cd_procedimento_p) || ',' || quote_nullable(ie_origem_proced_p) || ',' || quote_nullable(nr_seq_proc_interno_p) || ',' || quote_nullable(ie_tipo_atendimento_p) || ',' || quote_nullable(cd_plano_p) || ',' || quote_nullable(cd_setor_atendimento_p) || ',' || quote_nullable(cd_categoria_p) || ',' || quote_nullable(cd_estabelecimento_p) || ',' || quote_nullable(nr_sequencia_p) || ',' || quote_nullable(cd_medico_p) || ',' || quote_nullable(cd_pessoa_fisica_p) || ',' || quote_nullable(ie_autorizacao_p) || ',' || quote_nullable(ie_regra_p) || ',' || quote_nullable(ds_erro_p) || ',' || quote_nullable(cd_tipo_acomodacao_p) || ',' || quote_nullable(cd_usuario_convenio_p) || ',' || quote_nullable(ie_carater_cirurgia_p) || ' )';
	SELECT * FROM dblink(v_conn_str, v_query) AS p (v_ret0 text, v_ret1 bigint, v_ret2 text) INTO ie_autorizacao_p, ie_regra_p, ds_erro_p;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE verif_autorizacao_conv_age_pac_atx (nr_atendimento_p bigint, cd_convenio_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, ie_tipo_atendimento_p bigint, cd_plano_p text, cd_setor_atendimento_p bigint, cd_categoria_p text, cd_estabelecimento_p bigint, nr_sequencia_p bigint, cd_medico_p text, cd_pessoa_fisica_p text, ie_autorizacao_p INOUT text, ie_regra_p INOUT bigint, ds_erro_p INOUT text, cd_tipo_acomodacao_p bigint, cd_usuario_convenio_p text, ie_carater_cirurgia_p text) AS $body$
DECLARE


ds_erro_w		varchar(255);
ie_regra_w		integer;
nr_seq_regra_w		bigint;
ie_glosa_w		varchar(1);
cd_proc_adic_w		bigint;
ie_origem_proc_adic_w	bigint;
nr_seq_proc_adic_w	bigint;	
nr_sequencia_w		bigint;	
cd_estabelecimento_w	smallint;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
nr_seq_proc_interno_w   bigint;
ie_autorizacao_w	varchar(1);
ie_resp_autor_w		varchar(10);
vl_procedimento_w	double precision;
ie_tipo_convenio_w	smallint;
ie_edicao_w             varchar(1);
ie_pacote_w		varchar(1);
qt_item_edicao_w        bigint;
cd_convenio_partic_w    integer;
cd_categoria_partic_w   varchar(10);
ds_regra_w		varchar(30);
nr_seq_regra_ajuste_w	bigint;	
ie_prioridade_ajuste_proc_w	varchar(01);
cd_edicao_amb_w			integer		:= 0;
tx_ajuste_geral_w		double precision		:= 1;
dt_inicio_vigencia_w		timestamp;
vl_ch_honorarios_w		double precision := 1;
vl_ch_custo_oper_w	double precision := 1;
vl_m2_filme_w		double precision := 0;
nr_seq_cbhpm_edicao_w	bigint;
cd_edicao_ajuste_w		integer		:= 0;
BEGIN

SELECT * FROM consiste_plano_convenio(nr_atendimento_p, cd_convenio_p, cd_procedimento_p, ie_origem_proced_p, clock_timestamp(), 0, ie_tipo_atendimento_p, cd_plano_p, null, ds_erro_w, cd_setor_atendimento_p, 0, ie_Regra_w, nr_sequencia_p, nr_seq_regra_w, nr_seq_proc_interno_p, cd_categoria_p, cd_estabelecimento_p, 0, cd_medico_p, cd_pessoa_fisica_p, ie_glosa_w, nr_seq_regra_ajuste_w, null, null, cd_tipo_acomodacao_p, cd_usuario_convenio_p, ie_carater_cirurgia_p) INTO STRICT ds_erro_w, ie_Regra_w, nr_seq_regra_w, ie_glosa_w, nr_seq_regra_ajuste_w;
	
select	max(ie_tipo_convenio)
into STRICT	ie_tipo_convenio_w
from	convenio
where	cd_convenio	= cd_convenio_p;

select	coalesce(max(ie_prioridade_ajuste_proc), 'N')
into STRICT	ie_prioridade_ajuste_proc_w
from	parametro_faturamento
where	cd_estabelecimento	= cd_estabelecimento_p;
	
ie_edicao_w	:= Obter_Se_proc_Edicao(cd_estabelecimento_p, cd_convenio_p, cd_categoria_p, clock_timestamp(), cd_procedimento_p, ie_tipo_atendimento_p, ie_origem_proced_p,nr_seq_proc_interno_p);

ie_pacote_w	:= obter_Se_pacote_convenio(cd_procedimento_p, ie_origem_proced_p, cd_convenio_p, cd_estabelecimento_p);

/*      	obter ediçao da amb  */

if (ie_prioridade_ajuste_proc_w		= 'N') then
	select	coalesce(max(cd_edicao_amb),0),
			coalesce(max(tx_ajuste_geral),1)
	into STRICT	cd_edicao_amb_w,
			tx_ajuste_geral_w
	from	convenio_amb
	where	cd_estabelecimento	= cd_estabelecimento_p
	and		cd_convenio		= cd_convenio_p
	and		coalesce(ie_situacao,'A')	= 'A'
	and		cd_categoria		= cd_categoria_p
	and		dt_inicio_vigencia	=
		(SELECT max(dt_inicio_vigencia)
		from		convenio_amb a
		where		a.cd_estabelecimento	= cd_estabelecimento_p
		and		coalesce(a.ie_situacao,'A')	= 'A'
		and		a.cd_convenio		= cd_convenio_p
		and		a.cd_categoria		= cd_categoria_p
		and		a.dt_inicio_vigencia 	<= clock_timestamp());
else
	SELECT * FROM obter_edicao_proc_conv(cd_estabelecimento_p, cd_convenio_p, cd_categoria_p, clock_timestamp(), cd_procedimento_p, cd_edicao_amb_w, vl_ch_honorarios_w, vl_ch_custo_oper_w, vl_m2_filme_w, dt_inicio_vigencia_w, tx_ajuste_geral_w, nr_seq_cbhpm_edicao_w) INTO STRICT cd_edicao_amb_w, vl_ch_honorarios_w, vl_ch_custo_oper_w, vl_m2_filme_w, dt_inicio_vigencia_w, tx_ajuste_geral_w, nr_seq_cbhpm_edicao_w;
end if;


select 	max(CASE WHEN coalesce(IE_CONSISTE_EDICAO_PRIOR,'N')='S' THEN	    CASE WHEN obter_se_proced_edicao(cd_procedimento_p, ie_origem_proced_p, cd_edicao_amb, ie_prior_edicao_ajuste)='S' THEN  cd_edicao_amb  ELSE cd_edicao_amb_w END   ELSE coalesce(cd_edicao_amb,cd_edicao_amb_w) END )
into STRICT 	cd_edicao_ajuste_w
from    regra_ajuste_proc
where   nr_sequencia = nr_seq_regra_ajuste_w;


if (ie_edicao_w 				= 'N') and (coalesce(cd_edicao_ajuste_w,0) 	= 0) and (coalesce(ie_glosa_w,'L') 		= 'L') and (ie_pacote_w				= 'N') then
	ie_glosa_w        			:= 'T';
end if;
	
					      
if (ie_edicao_w 				= 'N') and (coalesce(cd_edicao_ajuste_w,0) 	> 0) and (coalesce(ie_glosa_w,'L') 		= 'L') and (ie_pacote_w				= 'N') then
			
		select   count(*)
		into STRICT     qt_item_edicao_w
		from     preco_amb
		where    cd_edicao_amb = cd_edicao_ajuste_w
		and      cd_procedimento = cd_procedimento_w
		and      ie_origem_proced = ie_origem_proced_w;
						
		if (qt_item_edicao_w = 0) then
			ie_glosa_w :=    'G';
		end if;
					
end if;
			
ie_autorizacao_p	:= 'L';

if (ie_Regra_w in (1,2,5)) or (ie_Regra_w = 8) then
	
	ie_autorizacao_p	:= 'B';
	
elsif (ie_Regra_w in (3,6,7)) then

	select 	coalesce(max(ie_resp_autor),'H')
	into STRICT	ie_resp_autor_w
	from 	regra_convenio_plano
	where 	nr_sequencia = nr_seq_regra_w;
	
	if (ie_resp_autor_w	= 'H') then
		ie_autorizacao_p	:= 'PAH';
	
	elsif (ie_resp_autor_w	= 'P') then
		ie_autorizacao_p	:= 'PAP';
	end if;
end if;

							
if (ie_glosa_w in ('G','T','D','F')) then

	ie_autorizacao_p	:= 'B';
	
end if;
		
ie_regra_p := ie_regra_w;
ds_erro_p  := ds_erro_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE verif_autorizacao_conv_age_pac (nr_atendimento_p bigint, cd_convenio_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, ie_tipo_atendimento_p bigint, cd_plano_p text, cd_setor_atendimento_p bigint, cd_categoria_p text, cd_estabelecimento_p bigint, nr_sequencia_p bigint, cd_medico_p text, cd_pessoa_fisica_p text, ie_autorizacao_p INOUT text, ie_regra_p INOUT bigint, ds_erro_p INOUT text, cd_tipo_acomodacao_p bigint, cd_usuario_convenio_p text, ie_carater_cirurgia_p text) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE verif_autorizacao_conv_age_pac_atx (nr_atendimento_p bigint, cd_convenio_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, ie_tipo_atendimento_p bigint, cd_plano_p text, cd_setor_atendimento_p bigint, cd_categoria_p text, cd_estabelecimento_p bigint, nr_sequencia_p bigint, cd_medico_p text, cd_pessoa_fisica_p text, ie_autorizacao_p INOUT text, ie_regra_p INOUT bigint, ds_erro_p INOUT text, cd_tipo_acomodacao_p bigint, cd_usuario_convenio_p text, ie_carater_cirurgia_p text) FROM PUBLIC;
