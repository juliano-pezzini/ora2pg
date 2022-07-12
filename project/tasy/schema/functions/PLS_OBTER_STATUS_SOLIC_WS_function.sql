-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_status_solic_ws ( nr_seq_guia_p bigint) RETURNS bigint AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Obter o estágio da guia para retornar na Solicitação de Status, via WebService
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [   ] Portal [  ]  Relatórios [ x] Outros: Gerenciador de XML
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w		smallint;
ie_estagio_w		pls_guia_plano.ie_estagio%type;
ie_status_w		pls_guia_plano.ie_status%type;
ie_status_aud_w		pls_auditoria.ie_status%type;


BEGIN

if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then
	begin
		select 	ie_estagio,
			ie_status
		into STRICT	ie_estagio_w,
			ie_status_w
		from 	pls_guia_plano
		where	nr_sequencia = nr_seq_guia_p;
	exception
	when others then
		ie_estagio_w	:= null;
		ie_status_w	:= null;
	end;

	case(ie_estagio_w)
		when 1 then
			begin
				select	ie_status
				into STRICT	ie_status_aud_w
				from	pls_auditoria
				where	nr_seq_guia	= nr_seq_guia_p
				and	coalesce(dt_liberacao::text, '') = '';
			exception
			when others then
				ie_status_aud_w		:= null;
			end;

			if (ie_status_aud_w = 'AJ') then
				ds_retorno_w	:= 4;
			elsif (ie_status_aud_w in ('AF', 'ACO', 'AAG')) then
				ds_retorno_w	:= 5;
			elsif (ie_status_aud_w in ('A', 'AP', 'AE', 'EC')) then
				ds_retorno_w	:= 2;
			end if;
		when 8 then
			ds_retorno_w	:= 6;
		when 10 then
			ds_retorno_w	:= 7;
		else
			ds_retorno_w	:= (coalesce(ie_status_w,2))::numeric;
	end case;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_status_solic_ws ( nr_seq_guia_p bigint) FROM PUBLIC;

