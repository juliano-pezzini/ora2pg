-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_proposta_gerar_log ( nr_seq_proposta_p bigint, nr_seq_contrato_p bigint, nr_seq_plano_p bigint, ie_tipo_p text, nr_seq_beneficiario_p bigint, nr_seq_titular_p bigint, nr_seq_grau_parentesco_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_grau_parentesco_w		varchar(40);
ds_tipo_parentesco_w		varchar(120);


BEGIN

if (coalesce(nr_seq_grau_parentesco_p,0) > 0) then
	begin
	select	ds_parentesco,
		substr(obter_valor_dominio(1885, ie_tipo_parentesco),1,120)
	into STRICT	ds_grau_parentesco_w,
		ds_tipo_parentesco_w
	from	grau_parentesco
	where	nr_sequencia	= nr_seq_grau_parentesco_p;
	exception
		when others then
		ds_grau_parentesco_w	:= '';
		ds_tipo_parentesco_w	:= '';
	end;
end if;

insert into pls_proposta_contrato_log(nr_sequencia, dt_atualizacao, nm_usuario,
	nr_seq_proposta, nr_seq_contrato, nr_seq_plano,
	ie_tipo, nr_seq_beneficiario, nr_seq_titular,
	ds_parentesco, ds_tipo_parentesco)
values (	nextval('pls_proposta_contrato_log_seq'), clock_timestamp(), nm_usuario_p,
	nr_seq_proposta_p, nr_seq_contrato_p, nr_seq_plano_p,
	ie_tipo_p, nr_seq_beneficiario_p, nr_seq_titular_p,
	ds_grau_parentesco_w, ds_tipo_parentesco_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_proposta_gerar_log ( nr_seq_proposta_p bigint, nr_seq_contrato_p bigint, nr_seq_plano_p bigint, ie_tipo_p text, nr_seq_beneficiario_p bigint, nr_seq_titular_p bigint, nr_seq_grau_parentesco_p bigint, nm_usuario_p text) FROM PUBLIC;

