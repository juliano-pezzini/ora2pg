-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_def_infect_med_vis_js ( nr_seq_def_infect_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;
nr_sequencias_w		varchar(2000);
nr_pos_virgula_w	bigint;
nr_seq_producao_w	bigint;


BEGIN
if (nr_seq_def_infect_p IS NOT NULL AND nr_seq_def_infect_p::text <> '') then
	nr_sequencias_w	:= nr_seq_def_infect_p;
	while(nr_sequencias_w IS NOT NULL AND nr_sequencias_w::text <> '') loop
		begin
		nr_pos_virgula_w	:= position(',' in nr_sequencias_w);
		if (nr_pos_virgula_w > 0) then
			begin
			nr_sequencia_w	:= (substr(nr_sequencias_w,1,nr_pos_virgula_w-1))::numeric;
			nr_sequencias_w	:= substr(nr_sequencias_w,nr_pos_virgula_w+1,length(nr_sequencias_w));
			if (nr_sequencia_w > 0) then
				begin
				CALL cih_insert_def_infect_med_vis( nr_sequencia_w,nm_usuario_p);
				end;
			end if;
		end;
		end if;
	end;
	end loop;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_def_infect_med_vis_js ( nr_seq_def_infect_p text, nm_usuario_p text) FROM PUBLIC;
