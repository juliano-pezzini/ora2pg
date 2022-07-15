-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_itens_grupo_fluxo ( nr_seq_grupo_p bigint, ie_identificacao_p text, nm_usuario_p text) AS $body$
DECLARE


ie_origem_valor_w	regra_comp_item.ie_origem_valor%type;


BEGIN

if (ie_identificacao_p	in ('11')) then

	ie_origem_valor_w	:= 'B';

elsif (ie_identificacao_p	in ('4','1','7','8','9','10','12','13','5','6','19','22','23','24','25','26')) then

	ie_origem_valor_w	:= 'C';
else

	ie_origem_valor_w	:= 'N';

end if;

insert	into regra_comp_item(dt_atualizacao,
	dt_atualizacao_nrec,
	ie_identificacao,
	nm_usuario,
	nm_usuario_nrec,
	nr_seq_grupo,
	nr_sequencia,
	ie_origem_valor)
values (clock_timestamp(),
	clock_timestamp(),
	ie_identificacao_p,
	nm_usuario_p,
	nm_usuario_p,
	nr_seq_grupo_p,
	nextval('regra_comp_item_seq'),
	ie_origem_valor_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_itens_grupo_fluxo ( nr_seq_grupo_p bigint, ie_identificacao_p text, nm_usuario_p text) FROM PUBLIC;

