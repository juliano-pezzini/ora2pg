-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dados_envelope_js ( ie_retorno_p INOUT text, nr_confere_p bigint, nr_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_existe_w	bigint;
ie_checado_w	bigint;
ie_atend_w	bigint;
ie_retorno_w	varchar(1);

BEGIN

if (nr_confere_p IS NOT NULL AND nr_confere_p::text <> '') then
	begin
	select	count(*)
	into STRICT	ie_existe_w
	from	envelope_laudo
	where	nr_sequencia = nr_confere_p;

	select	count(*)
	into STRICT	ie_checado_w
	from	envelope_laudo
	where	(dt_checagem IS NOT NULL AND dt_checagem::text <> '')
	and	nr_sequencia = nr_confere_p;
	end;

	if (ie_checado_w > 0) then
		begin
		ie_retorno_w := '0';
		end;

	elsif (ie_existe_w > 0) then
		begin
		select	count(*)
		into STRICT	ie_atend_w
		from	prescr_medica a,
			envelope_laudo_item b
		where	a.nr_prescricao = b.nr_prescricao
		and	a.nr_atendimento  = nr_atendimento_p
		and	b.nr_seq_envelope = nr_confere_p;

		if (ie_atend_w > 0) then
			begin
			ie_retorno_w := '1';
			end;
		else
			begin
			ie_retorno_w := '2';
			end;
		end if;
		end;

	else
		begin
		ie_retorno_w := '3';
		end;
	end if;
end if;
ie_retorno_p	:= ie_retorno_w;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dados_envelope_js ( ie_retorno_p INOUT text, nr_confere_p bigint, nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

