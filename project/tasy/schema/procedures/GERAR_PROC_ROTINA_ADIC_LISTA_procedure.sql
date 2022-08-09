-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_proc_rotina_adic_lista ( nr_seq_agenda_p bigint, ds_grupo_qt_lista_p text, nm_usuario_p text) AS $body$
DECLARE


ds_grupo_qt_lista_w	varchar(2000);
ds_proced_w			varchar(200);
qt_procedimento_w	bigint;
nr_seq_grupo_item_w bigint;
ie_lado_w			varchar(1);
ie_pos_separador_w	integer;
qt_tam_lista_w		bigint;
ie_pos_virgula_w 	integer;
ds_pos_separador_w	varchar(255);



BEGIN

ds_grupo_qt_lista_w	:= ds_grupo_qt_lista_p;

while(ds_grupo_qt_lista_w IS NOT NULL AND ds_grupo_qt_lista_w::text <> '') loop
	begin
		qt_tam_lista_w		:= length(ds_grupo_qt_lista_w);
		ie_pos_virgula_w	:= position(',' in ds_grupo_qt_lista_w);


		if (ie_pos_virgula_w <> 0) then
			begin
				ds_proced_w		:= substr(ds_grupo_qt_lista_w,1,(ie_pos_virgula_w - 1));
				ds_grupo_qt_lista_w	:= substr(ds_grupo_qt_lista_w,(ie_pos_virgula_w + 1),qt_tam_lista_w);


				ie_pos_separador_w	:= position('-' in ds_proced_w);
				nr_seq_grupo_item_w	:= (substr(ds_proced_w,1,(ie_pos_separador_w - 1)))::numeric;

				ds_pos_separador_w 	:= substr(ds_proced_w,ie_pos_separador_w + 1,(ie_pos_virgula_w - 1));
				ie_pos_separador_w	:= position('-' in ds_pos_separador_w );

				begin
					ie_lado_w	:= substr(ds_pos_separador_w,1,(ie_pos_separador_w - 1));
					if (ie_lado_w = 'null') then
						ie_lado_w := null;
					end if;
				exception
					when others then
					ie_lado_w := null;
				end;


				ds_pos_separador_w 	:= substr(ds_pos_separador_w,ie_pos_separador_w + 1,(ie_pos_virgula_w - 1));
				ie_pos_separador_w	:= position('-' in ds_pos_separador_w );

				begin
					qt_procedimento_w	:= (substr(ds_pos_separador_w,1,(ie_pos_separador_w - 1)))::numeric;
					if (qt_procedimento_w = 0) then
						qt_procedimento_w := 1;
					end if;
				exception
					when others then
					qt_procedimento_w := 1;
				end;

			end;
		else
			begin
				ie_pos_separador_w	:= position('-' in ds_grupo_qt_lista_w);
				nr_seq_grupo_item_w	:= (substr(ds_grupo_qt_lista_w,1,(ie_pos_separador_w - 1)))::numeric;

				ds_pos_separador_w 	:= substr(ds_proced_w,ie_pos_separador_w + 1,(ie_pos_virgula_w - 1));
				ie_pos_separador_w	:= position('-' in ds_pos_separador_w);

				begin
					ie_lado_w	:= substr(ds_pos_separador_w,1,(ie_pos_separador_w - 1));
					if (ie_lado_w = 'null') then
						ie_lado_w := null;
					end if;
				exception
					when others then
					ie_lado_w := null;
				end;

				ds_pos_separador_w 	:= substr(ds_pos_separador_w,ie_pos_separador_w + 1,(ie_pos_virgula_w - 1));
				ie_pos_separador_w	:= position('-' in ds_pos_separador_w );

				begin
					qt_procedimento_w	:= (substr(ds_pos_separador_w,1,(ie_pos_separador_w - 1)))::numeric;
					if (qt_procedimento_w = 0) then
						qt_procedimento_w := 1;
					end if;
				exception
					when others then
					qt_procedimento_w := 1;
				end;


				ds_grupo_qt_lista_w	:= null;
			end;
		end if;

		if (nr_seq_grupo_item_w IS NOT NULL AND nr_seq_grupo_item_w::text <> '') and (nr_seq_grupo_item_w > 0) then
			begin

			CALL gerar_proc_rotina_adicional(
				nr_seq_agenda_p,
				nr_seq_grupo_item_w,
				qt_procedimento_w,
				nm_usuario_p,
				wheb_usuario_pck.get_cd_estabelecimento,
				ie_lado_w);
			end;
		end if;
	end;
end loop;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_proc_rotina_adic_lista ( nr_seq_agenda_p bigint, ds_grupo_qt_lista_p text, nm_usuario_p text) FROM PUBLIC;
