-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_consiste_laudo_siscolo ( nr_seq_laudo_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_detalhe_w			varchar(255)	:= '';
cd_estabelecimento_w  		smallint;
cd_profissional_w     		varchar(10);
dt_emissao_w          		timestamp;
dt_liberacao_w        		timestamp;
nr_atendimento_w      		bigint;
nr_seq_sisco_w			bigint;
cd_cnpj_unidade_saude_w		varchar(14);
nr_seq_unidade_saude_w		bigint;
nr_cartao_nac_sus_w		varchar(20);
qt_idade_w			bigint;
nr_identidade_w			varchar(15);
ds_orgao_emissor_ci_w		pessoa_fisica.ds_orgao_emissor_ci%type;
sg_emissora_ci_w			varchar(2);
cd_cns_profissional_w		varchar(15);
cd_cpf_profissional_w		varchar(11);
nm_mae_w			varchar(50);
dt_nascimento_w			timestamp;
nr_numero_w			varchar(6);
qt_anamnese_w			bigint;
qt_avaliacao_w			bigint;
qt_diagnostico_w			bigint;
qt_atipias_w			bigint;
dt_entrada_w			timestamp;
dt_lib_siscolo_w		timestamp;
ie_sinal_dst_w			varchar(1);
dt_liberacao_atp_w		timestamp;
dt_emissao_sis_w		timestamp;


BEGIN

delete	from sus_inco_reg_laudo
where	nr_seq_laudo	= nr_seq_laudo_p;

/*Obter os dados do Laudo*/

begin
select	a.nr_sequencia,
	a.cd_estabelecimento,
	a.cd_profissional,
	a.dt_emissao,
	a.nr_atendimento,
	c.nr_cartao_nac_sus,
	Obter_Idade_PF(c.cd_pessoa_fisica,clock_timestamp(),'A'),
	nr_identidade,
	ds_orgao_emissor_ci,
	sg_emissora_ci,
	substr(obter_dados_pf(a.cd_profissional,'CNS'),1,15),
	substr(obter_dados_pf(a.cd_profissional,'CPF'),1,11),
	substr(obter_compl_pf(c.cd_pessoa_fisica,5,'N'),1,50),
	c.dt_nascimento,
	substr(obter_compl_pf(c.cd_pessoa_fisica,1,'NR'),1,6),
	b.dt_entrada
into STRICT	nr_seq_sisco_w,
	cd_estabelecimento_w,
	cd_profissional_w,
	dt_emissao_w,
	nr_atendimento_w,
	nr_cartao_nac_sus_w,
	qt_idade_w,
	nr_identidade_w,
	ds_orgao_emissor_ci_w,
	sg_emissora_ci_w,
	cd_cns_profissional_w,
	cd_cpf_profissional_w,
	nm_mae_w,
	dt_nascimento_w,
	nr_numero_w,
	dt_entrada_w
from	pessoa_fisica 		c,
	atendimento_paciente 	b,
	siscolo_atendimento	a
where	a.nr_sequencia 	 	= nr_seq_laudo_p
and	a.nr_atendimento 	= b.nr_atendimento
and	b.cd_pessoa_fisica	= c.cd_pessoa_fisica;
exception
	when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(174941);
	/*'Problemas para obter as informacoes do atendimento ao consistir o laudo.'*/

	end;

if (sus_obter_tp_laudo_siscolo(nr_seq_laudo_p,1) = '1') then
	begin
	
	if (sus_obter_incolaudo_ativa(69))  then
	
		select	count(*)
		into STRICT	qt_anamnese_w
		from	siscolo_cito_anamnese
		where	nr_seq_siscolo = nr_seq_sisco_w;
		
		select	count(*)
		into STRICT	qt_avaliacao_w
		from	siscolo_cito_avaliacao
		where	nr_seq_siscolo = nr_seq_sisco_w;
		
		select	count(*)
		into STRICT	qt_diagnostico_w
		from	siscolo_cito_diagnostico
		where	nr_seq_siscolo = nr_seq_sisco_w;
		
		select	count(*)
		into STRICT	qt_atipias_w
		from	siscolo_cito_atipias
		where	nr_seq_siscolo = nr_seq_sisco_w;
		
		if (qt_anamnese_w = 0) or (qt_avaliacao_w = 0) or (qt_diagnostico_w = 0) or (qt_atipias_w = 0) then
			begin
			ds_detalhe_w	:= substr('Atend.: ' || nr_atendimento_w || ', Laudo: ' || nr_seq_sisco_w,1,255);
			CALL Sus_Laudo_Gravar_Inco(nr_seq_sisco_w, 69, ds_detalhe_w, cd_estabelecimento_w, nm_usuario_p);
			end;
		end if;	
	end if;
	
	if (sus_obter_incolaudo_ativa(75)) then
		begin

		begin
		select	dt_liberacao
		into STRICT	dt_lib_siscolo_w
		from	siscolo_cito_atipias
		where	nr_seq_siscolo = nr_seq_sisco_w;
		exception
		when others then
			dt_lib_siscolo_w := null;
		end;
		
		if (dt_lib_siscolo_w IS NOT NULL AND dt_lib_siscolo_w::text <> '') and (ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_lib_siscolo_w) < ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_entrada_w)) then
			begin
			ds_detalhe_w	:= substr('Atend.: ' || nr_atendimento_w || ', Laudo: ' || nr_seq_sisco_w,1,255);
			CALL Sus_Laudo_Gravar_Inco(nr_seq_sisco_w, 75, ds_detalhe_w, cd_estabelecimento_w, nm_usuario_p);		
			end;
		end if;
		
		end;
	end if;
	
	if (sus_obter_incolaudo_ativa(76)) then
		begin
		
		begin
		select	coalesce(ie_sinal_dst,'0')
		into STRICT	ie_sinal_dst_w
		from	siscolo_cito_anamnese
		where	nr_seq_siscolo   = nr_seq_sisco_w;
		exception
		when others then
			ie_sinal_dst_w := '0';
		end;
	
		end;
	
		if (ie_sinal_dst_w = '0') then
			begin
			ds_detalhe_w	:= substr('Atend.: ' || nr_atendimento_w || ', Laudo: ' || nr_seq_sisco_w,1,255);
			CALL Sus_Laudo_Gravar_Inco(nr_seq_sisco_w, 76, ds_detalhe_w, cd_estabelecimento_w, nm_usuario_p);
			end;
		end if;
	
	end if;
	
	
	if (sus_obter_incolaudo_ativa(77)) and (coalesce(nr_identidade_w,'0') <> '0') and (coalesce(ds_orgao_emissor_ci_w,'0') = '0') then
		begin
		ds_detalhe_w	:= 'Atend.: ' || nr_atendimento_w || ', Laudo: ' || nr_seq_sisco_w;
		CALL Sus_Laudo_Gravar_Inco(nr_seq_laudo_p, 77, ds_detalhe_w, cd_estabelecimento_w, nm_usuario_p);
		end;
	end if;

	if (sus_obter_incolaudo_ativa(78)) then
		begin

		select	max(a.dt_emissao)
		into STRICT	dt_emissao_sis_w
		from	siscolo_atendimento a
		where	(((SELECT count(1)
		from	siscolo_cito_anamnese x
		where	x.nr_seq_siscolo = a.nr_sequencia  LIMIT 1) > 0) and
		((select count(1)
		from	siscolo_cito_atipias x
		where	x.nr_seq_siscolo = a.nr_sequencia  LIMIT 1) > 0) and
		((select count(1)
		from	siscolo_cito_avaliacao x
		where	x.nr_seq_siscolo = a.nr_sequencia  LIMIT 1) > 0) and
		(((select count(1)
		from	siscolo_cito_diagnostico x
		where	x.nr_seq_siscolo = a.nr_sequencia  LIMIT 1) > 0) or
		((select count(1)
		from	siscolo_cito_avaliacao x
		where	x.nr_seq_siscolo = a.nr_sequencia
		and	ie_adequabilidade = 'I'  LIMIT 1) > 0)))
		and	a.nr_sequencia = nr_seq_sisco_w;
		
		if (coalesce(dt_emissao_sis_w::text, '') = '') then
			begin
			ds_detalhe_w	:= substr('Atend.: ' || nr_atendimento_w || ', Laudo: ' || nr_seq_sisco_w,1,255);
			CALL Sus_Laudo_Gravar_Inco(nr_seq_sisco_w, 78, ds_detalhe_w, cd_estabelecimento_w, nm_usuario_p);
			end;
		end if;
		
		end;
	end if;

	if (sus_obter_incolaudo_ativa(79)) then
		begin

		select	max(dt_liberacao)
		into STRICT	dt_liberacao_atp_w
		from	siscolo_cito_atipias
		where	nr_seq_siscolo	= nr_seq_sisco_w;
		
		end;
		
		if (coalesce(dt_liberacao_atp_w::text, '') = '') then
			begin
			ds_detalhe_w	:= substr('Atend.: ' || nr_atendimento_w || ', Laudo: ' || nr_seq_sisco_w,1,255);
			CALL Sus_Laudo_Gravar_Inco(nr_seq_sisco_w, 79, ds_detalhe_w, cd_estabelecimento_w, nm_usuario_p);
			end;
		end if;
		
	end if;
	
	end;
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_consiste_laudo_siscolo ( nr_seq_laudo_p bigint, nm_usuario_p text) FROM PUBLIC;
