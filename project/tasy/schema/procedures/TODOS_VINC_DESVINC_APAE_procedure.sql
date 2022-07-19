-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE todos_vinc_desvinc_apae ( nr_seq_apae_lista_p text, nr_cirurgia_p bigint, ie_opcao_p text) AS $body$
DECLARE


nr_seq_apae_lista_w	varchar(255);
nr_controle_loop_w	smallint 	:= 0;
nr_apos_virgula_w	bigint	:= 0;
nr_seq_apae_w		bigint	:= 0;


BEGIN
if (nr_seq_apae_lista_p IS NOT NULL AND nr_seq_apae_lista_p::text <> '') then
	begin
	nr_seq_apae_lista_w :=  nr_seq_apae_lista_p;
	while((nr_seq_apae_lista_w IS NOT NULL AND nr_seq_apae_lista_w::text <> '') and nr_controle_loop_w < 1000) loop
		begin
		nr_controle_loop_w	:= nr_controle_loop_w + 1;
		nr_apos_virgula_w 	:= position(',' in nr_seq_apae_lista_w);
		if (nr_apos_virgula_w > 0) then
			begin
			nr_seq_apae_w 		:= (substr(nr_seq_apae_lista_w, 1, nr_apos_virgula_w -1))::numeric;
			nr_seq_apae_lista_w 	:= substr(nr_seq_apae_lista_w, nr_apos_virgula_w +1, length(nr_seq_apae_lista_w));
			if (nr_seq_apae_w > 0) then
				begin
				CALL vincular_desvincular_apae( nr_seq_apae_w,
							   nr_cirurgia_p,
							   ie_opcao_p);
				end;
			end if;
			end;
		else
			nr_seq_apae_lista_w := null;
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
-- REVOKE ALL ON PROCEDURE todos_vinc_desvinc_apae ( nr_seq_apae_lista_p text, nr_cirurgia_p bigint, ie_opcao_p text) FROM PUBLIC;

