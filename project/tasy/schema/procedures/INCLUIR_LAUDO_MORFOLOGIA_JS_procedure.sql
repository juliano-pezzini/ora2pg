-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE incluir_laudo_morfologia_js ( nr_seq_laudo_p bigint, nr_prescricao_p bigint, nr_seq_prescr_p bigint, ds_lista_morfologia_p text, nm_usuario_p text) AS $body$
DECLARE


cd_morfologia_w		bigint;
ds_lista_morfologia_w	varchar(2000);
nr_pos_virgula_w	bigint;
nr_seq_peca_w		bigint;


BEGIN

if (nr_seq_laudo_p IS NOT NULL AND nr_seq_laudo_p::text <> '')then
	begin

	ds_lista_morfologia_w	:= ds_lista_morfologia_p;

	while(ds_lista_morfologia_w IS NOT NULL AND ds_lista_morfologia_w::text <> '') loop
		begin

		nr_pos_virgula_w	:= position(',' in ds_lista_morfologia_w);

		if (nr_pos_virgula_w > 0)then
			begin

			cd_morfologia_w		:= substr(ds_lista_morfologia_w,0,nr_pos_virgula_w-1);
			ds_lista_morfologia_w	:= substr(ds_lista_morfologia_w,nr_pos_virgula_w+1,length(ds_lista_morfologia_w));

			end;
		else
			begin

			ds_lista_morfologia_w	:= null;

			end;
		end if;

		if (coalesce(cd_morfologia_w,0) > 0) then
			begin

			select	a.nr_sequencia
			into STRICT	nr_seq_peca_w
			from	prescr_proc_peca a,
				tipo_amostra_pato_morf b
			where	a.nr_seq_amostra_princ = b.nr_seq_tipo_amostra_pato
			and	a.nr_prescricao = nr_prescricao_p
			and	a.nr_seq_prescr = nr_seq_prescr_p
			and	coalesce(a.nr_seq_peca::text, '') = ''
			and	b.cd_morfologia = cd_morfologia_w;

			if (nr_seq_peca_w IS NOT NULL AND nr_seq_peca_w::text <> '')then
				begin

				CALL incluir_morfologia_laudo(nr_seq_laudo_p, nr_seq_peca_w, cd_morfologia_w, nm_usuario_p);

				end;
			end if;

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
-- REVOKE ALL ON PROCEDURE incluir_laudo_morfologia_js ( nr_seq_laudo_p bigint, nr_prescricao_p bigint, nr_seq_prescr_p bigint, ds_lista_morfologia_p text, nm_usuario_p text) FROM PUBLIC;
