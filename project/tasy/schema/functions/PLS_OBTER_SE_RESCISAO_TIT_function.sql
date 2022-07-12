-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_rescisao_tit ( nr_titulo_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/* ie_opcao_p
	'I' = Inadimplencia
	'O' = Outros motivos
	'A' = Ativos
*/
/* Function que retorna se o título está aberto e o contrato rescindido por inadimplencia*/

ds_retorno_w			varchar(2) := 'N';
ie_situacao_w			varchar(1);
dt_rescisao_w			timestamp;
nr_seq_motivo_rescisao_w	bigint;
ie_inadimplencia_w		varchar(1);


BEGIN

select	max(c.dt_rescisao_contrato),
	max(b.ie_situacao),
	max(c.nr_seq_motivo_rescisao)
into STRICT	dt_rescisao_w,
	ie_situacao_w,
	nr_seq_motivo_rescisao_w
from	pls_mensalidade a,
	titulo_receber b,
	pls_contrato c
where	a.nr_sequencia	= b.nr_seq_mensalidade
and	c.nr_sequencia	= a.nr_seq_contrato
and	b.nr_titulo	= nr_titulo_p;

select	max(ie_inadimplencia)
into STRICT	ie_inadimplencia_w
from	pls_motivo_cancelamento
where	nr_sequencia	= nr_seq_motivo_rescisao_w;

if	((ie_inadimplencia_w = 'S') and (dt_rescisao_w IS NOT NULL AND dt_rescisao_w::text <> '') and (ie_opcao_p = 'I')) then
	ds_retorno_w := 'S';
elsif	((ie_inadimplencia_w = 'N') and (dt_rescisao_w IS NOT NULL AND dt_rescisao_w::text <> '') and (ie_opcao_p = 'O')) then
	ds_retorno_w := 'S';
elsif	((coalesce(dt_rescisao_w::text, '') = '') and (ie_opcao_p = 'A')) then
	ds_retorno_w := 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_rescisao_tit ( nr_titulo_p bigint, ie_opcao_p text) FROM PUBLIC;
