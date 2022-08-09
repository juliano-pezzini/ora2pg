-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_doador_email_padrao_js (nr_seq_corresp text) AS $body$
DECLARE


ds_lista_exclusao_w	varchar(2000);
nr_pos_virgula_w	bigint;
nr_seq_sequencia_w	bigint;


BEGIN

if (nr_seq_corresp IS NOT NULL AND nr_seq_corresp::text <> '') then
	begin
	 ds_lista_exclusao_w	:=	nr_seq_corresp;

	 while(ds_lista_exclusao_w IS NOT NULL AND ds_lista_exclusao_w::text <> '')	loop
	 	begin
	 	nr_pos_virgula_w := position(',' in ds_lista_exclusao_w);

		if (nr_pos_virgula_w > 0) then
			begin
			nr_seq_sequencia_w	:= (substr(ds_lista_exclusao_w,0,nr_pos_virgula_w-1))::numeric;
			ds_lista_exclusao_w	:= substr(ds_lista_exclusao_w,nr_pos_virgula_w+1,length(ds_lista_exclusao_w));
			end;
		else
			begin
			nr_seq_sequencia_w	:= (ds_lista_exclusao_w)::numeric;
			ds_lista_exclusao_w	:= null;
			end;
		end if;

		if (coalesce(nr_seq_sequencia_w,0) > 0)then
			begin

			delete
			from	san_doador_envio_item
			where	nr_sequencia = nr_seq_sequencia_w;

			end;
		end if;


	 	end;
	 end loop;

	end;
end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_doador_email_padrao_js (nr_seq_corresp text) FROM PUBLIC;
