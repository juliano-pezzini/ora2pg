-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cobranca_valor_terc ( nr_seq_cobranca_p bigint, nr_seq_terceiro_p bigint, vl_terceiro_p bigint, tx_perc_cobr_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text) AS $body$
DECLARE

vl_terceiro_w		double precision;
nr_seq_terceiro_w	bigint;
cd_estabelecimento_w	smallint;
ie_valor_terc_cobr_w	varchar(1);


BEGIN 
 
select	coalesce(max(ie_valor_terc_cobr),'D') 
into STRICT	ie_valor_terc_cobr_w 
from	parametro_contas_receber 
where	cd_estabelecimento = obter_estabelecimento_ativo;
 
if (nr_seq_terceiro_p IS NOT NULL AND nr_seq_terceiro_p::text <> '') and (tx_perc_cobr_p IS NOT NULL AND tx_perc_cobr_p::text <> '') then 
	begin 
	vl_terceiro_w	:= (coalesce(vl_terceiro_p,0) * coalesce(tx_perc_cobr_p,0))/100;	
 
	insert into cobranca_valor_terc( 
		nr_sequencia, 
		nr_seq_cobranca, 
		nr_seq_terceiro, 
		vl_terceiro, 
		dt_atualizacao, 
		nm_usuario, 
		ie_acao_valor) 
	values (	nextval('cobranca_valor_terc_seq'), 
		nr_seq_cobranca_p, 
		nr_seq_terceiro_p, 
		vl_terceiro_w, 
		clock_timestamp(), 
		nm_usuario_p, 
		CASE WHEN ie_valor_terc_cobr_w='S' THEN 'A'  ELSE ie_valor_terc_cobr_w END );
	end;
elsif (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (vl_terceiro_p IS NOT NULL AND vl_terceiro_p::text <> '') then 
	begin 
	select	cd_estabelecimento 
	into STRICT	cd_estabelecimento_w 
	from	cobranca 
	where	nr_sequencia = nr_seq_cobranca_p;
	 
	if (coalesce(nr_seq_terceiro_p::text, '') = '') then 
		nr_seq_terceiro_w	:= obter_terceiro_medico(cd_pessoa_fisica_p, cd_estabelecimento_w, clock_timestamp());
	else 
		nr_seq_terceiro_w	:= nr_seq_terceiro_p;
	end if;
	 
	insert into cobranca_valor_terc( 
		nr_sequencia, 
		nr_seq_cobranca, 
		dt_atualizacao, 
		nm_usuario, 
		nr_seq_terceiro, 
		vl_terceiro, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		ds_observacao, 
		cd_pessoa_fisica, 
		cd_cgc, 
		dt_recebimento, 
		nr_seq_tipo_terc, 
		ie_acao_valor) 
	values (	nextval('cobranca_valor_terc_seq'), 
		nr_seq_cobranca_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		nr_seq_terceiro_w, 
		vl_terceiro_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		null, 
		CASE WHEN coalesce(nr_seq_terceiro_w::text, '') = '' THEN  cd_pessoa_fisica_p  ELSE null END , 
		null, 
		null, 
		null, 
		CASE WHEN ie_valor_terc_cobr_w='S' THEN 'A'  ELSE ie_valor_terc_cobr_w END );
	end;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cobranca_valor_terc ( nr_seq_cobranca_p bigint, nr_seq_terceiro_p bigint, vl_terceiro_p bigint, tx_perc_cobr_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text) FROM PUBLIC;

