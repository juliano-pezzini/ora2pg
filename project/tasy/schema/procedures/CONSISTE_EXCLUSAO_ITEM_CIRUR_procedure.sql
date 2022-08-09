-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_exclusao_item_cirur ( nr_sequencia_p bigint, ie_opcao_p text, ds_retorno_p INOUT text) AS $body$
DECLARE

nr_laudo_w		bigint;
nr_seq_proc_pacote_w	bigint;
qt_laudo_w		smallint;


BEGIN

ds_retorno_p	:= null;

if (ie_opcao_p = 'P') then
	begin

	Select	max(nr_laudo),
		max(nr_seq_proc_pacote)
	into STRICT	nr_laudo_w,
		nr_seq_proc_pacote_w
	from	procedimento_paciente
	where	nr_sequencia = nr_sequencia_p;

	Select	count(1)
	into STRICT	qt_laudo_w
	from	laudo_paciente
	where	nr_seq_proc = nr_sequencia_p  LIMIT 1;

	if (nr_laudo_w IS NOT NULL AND nr_laudo_w::text <> '') or (qt_laudo_w > 0) then
		ds_retorno_p := substr(wheb_mensagem_pck.get_texto(179928),1,255);-- Este procedimento pertence a um laudo. Não pode ser excluido!
	end if;

	end;

elsif (ie_opcao_p = 'M') then
	begin

	Select	max(nr_seq_proc_pacote)
	into STRICT	nr_seq_proc_pacote_w
	from	material_atend_paciente
	where	nr_sequencia = nr_sequencia_p;

	if (nr_seq_proc_pacote_w IS NOT NULL AND nr_seq_proc_pacote_w::text <> '') then
		ds_retorno_p := substr(wheb_mensagem_pck.get_texto(304181),1,255); -- Este Material pertence a um pacote. Não pode ser excluido!
	end if;

	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_exclusao_item_cirur ( nr_sequencia_p bigint, ie_opcao_p text, ds_retorno_p INOUT text) FROM PUBLIC;
