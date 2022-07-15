-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_seq_status_processo ( nr_seq_processo_p bigint, ie_novo_status_processo_p text) AS $body$
DECLARE


ie_atual_status_processo_w	varchar(2);
ie_novo_status_processo_w	varchar(15);


BEGIN

if	(nr_seq_processo_p > 0 AND ie_novo_status_processo_p IS NOT NULL AND ie_novo_status_processo_p::text <> '') then

	if (ie_novo_status_processo_p = 'S') then
		ie_novo_status_processo_w := 'D';
	elsif (ie_novo_status_processo_p = 'H') then
		ie_novo_status_processo_w := 'H';
	elsif (ie_novo_status_processo_p = 'P') then
		ie_novo_status_processo_w := 'P';
	elsif (ie_novo_status_processo_p = 'C') then
		ie_novo_status_processo_w := 'L';
	elsif (ie_novo_status_processo_p = 'A') then
		ie_novo_status_processo_w := 'A';
	elsif (ie_novo_status_processo_p = 'F') then
		ie_novo_status_processo_w := 'L';
	end if;

	select	obter_status_processo(nr_seq_processo_p)
	into STRICT	ie_atual_status_processo_w
	;

	if (obter_seq_status_processo(ie_atual_status_processo_w) > obter_seq_status_processo(ie_novo_status_processo_w)) then
		/*(-20011, 'Este processo não poderá ser ' || obter_valor_dominio(2273,IE_NOVO_STATUS_PROCESSO_W) || ' pois já esta ' ||
						obter_valor_dominio(2273,IE_ATUAL_STATUS_PROCESSO_W) || '#@#@');*/
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(263587,	'IE_NOVO_STATUS_PROCESSO_W='||IE_NOVO_STATUS_PROCESSO_W || ';' ||
														'IE_ATUAL_STATUS_PROCESSO_W= '|| IE_ATUAL_STATUS_PROCESSO_W);
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_seq_status_processo ( nr_seq_processo_p bigint, ie_novo_status_processo_p text) FROM PUBLIC;

