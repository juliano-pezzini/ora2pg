-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_mensagem_reaj_pool ( nr_seq_contrato_p pls_contrato.nr_sequencia%type, dt_inicio_vigencia_p pls_grupo_contrato.dt_inicio_vigencia%type, dt_fim_vigencia_p pls_grupo_contrato.dt_fim_vigencia%type, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
ie_opcao_p
M	Mensagem
T	Taxa
S	Status
*/
				
ds_retorno_w		varchar(255);
nr_seq_reajuste_w	pls_reajuste.nr_sequencia%type;
tx_reajuste_w		pls_reajuste.tx_reajuste%type;
dt_reajuste_w		pls_reajuste.dt_reajuste%type;
ie_status_w		pls_reajuste.ie_status%type;
ds_mensagem_w		varchar(255);


BEGIN

ds_retorno_w	:= null;
tx_reajuste_w	:= null;
ie_status_w	:= null;

if	((nr_seq_contrato_p IS NOT NULL AND nr_seq_contrato_p::text <> '') and (dt_inicio_vigencia_p IS NOT NULL AND dt_inicio_vigencia_p::text <> '') and (dt_fim_vigencia_p IS NOT NULL AND dt_fim_vigencia_p::text <> '')) then
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_reajuste_w
	from	pls_reajuste a
	where	a.dt_reajuste between dt_inicio_vigencia_p and dt_fim_vigencia_p
	and     ((coalesce(a.ie_tipo_lote::text, '') = '') or ((a.ie_tipo_lote IS NOT NULL AND a.ie_tipo_lote::text <> '') and (coalesce(a.tx_reajuste_correto,0) <> 0)))
	and	a.nr_seq_contrato = nr_seq_contrato_p
	and	not exists (	SELECT	1
				from	pls_reajuste x
				where	x.nr_sequencia = a.nr_seq_lote_deflator);

	if (nr_seq_reajuste_w IS NOT NULL AND nr_seq_reajuste_w::text <> '') then
		select	CASE WHEN coalesce(tx_reajuste_correto,0)=0 THEN coalesce(tx_reajuste, 0)  ELSE tx_reajuste_correto END ,
			dt_reajuste,
			ie_status
		into STRICT	tx_reajuste_w,
			dt_reajuste_w,
			ie_status_w
		from	pls_reajuste
		where	nr_sequencia = nr_seq_reajuste_w;
		
		ds_mensagem_w	:= 'O reajuste aplicado em ' || to_char(dt_reajuste_w, 'mm/yyyy') || ' foi de ' || tx_reajuste_w || '%';
	else
		ds_mensagem_w	:= to_char(pls_obter_dt_reaj_contrato(nr_seq_contrato_p, dt_inicio_vigencia_p, dt_fim_vigencia_p), 'mm/yyyy') || ' - ' || wheb_mensagem_pck.get_texto(1125217);
	end if;
	
	if (ie_opcao_p = 'M') then
		ds_retorno_w	:= ds_mensagem_w;
	elsif (ie_opcao_p = 'T') then
		ds_retorno_w	:= to_char(tx_reajuste_w);
	elsif (ie_opcao_p = 'S') then
		ds_retorno_w	:= ie_status_w;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_mensagem_reaj_pool ( nr_seq_contrato_p pls_contrato.nr_sequencia%type, dt_inicio_vigencia_p pls_grupo_contrato.dt_inicio_vigencia%type, dt_fim_vigencia_p pls_grupo_contrato.dt_fim_vigencia%type, ie_opcao_p text) FROM PUBLIC;

