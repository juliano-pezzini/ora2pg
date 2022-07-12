-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION surgery_pck.get_participantes (nr_cirurgia_p bigint) RETURNS SETOF T_OBJETO_ROW_DATA AS $body$
DECLARE


t_objeto_row_w						t_objeto_row;
nm_profissional_anterior_w		varchar(60) := 'XPTO';

participantes CURSOR FOR
	SELECT	obter_initcap(substr(obter_nome_pf(a.cd_pessoa_fisica),1,60)) nm_profissional,
				ie_anestesista,
				ie_instrumentador,
				ie_medico,
				ie_auxiliar
	from		cirurgia_participante a,
				funcao_medico b
	where		a.ie_funcao 	= to_char(b.cd_funcao)
	and		a.nr_cirurgia 	= nr_cirurgia_p
	order by	1 desc;

BEGIN

if (coalesce(nr_cirurgia_p,0) > 0) then
	FOR r_c01 IN participantes LOOP
		begin
		if (r_c01.nm_profissional IS NOT NULL AND r_c01.nm_profissional::text <> '') then
			if (r_c01.ie_instrumentador = 'S') and (coalesce(position(r_c01.nm_profissional in t_objeto_row_w.nm_instrumentadores),0) = 0) then
				if (coalesce(t_objeto_row_w.nm_instrumentadores::text, '') = '') then
					t_objeto_row_w.nm_instrumentadores := r_c01.nm_profissional;
				else
					t_objeto_row_w.nm_instrumentadores := r_c01.nm_profissional ||', '||t_objeto_row_w.nm_instrumentadores;
				end if;
			end if;

			if (r_c01.ie_instrumentador = 'N') and (r_c01.ie_medico = 'N') and (r_c01.ie_anestesista = 'N') and (r_c01.ie_auxiliar = 'N') and (coalesce(position(r_c01.nm_profissional in t_objeto_row_w.nm_circulantes),0) = 0) then
				if (coalesce(t_objeto_row_w.nm_circulantes::text, '') = '') then
					t_objeto_row_w.nm_circulantes := r_c01.nm_profissional;
				else
					t_objeto_row_w.nm_circulantes := r_c01.nm_profissional ||', '||t_objeto_row_w.nm_circulantes;
				end if;
			end if;

			if (r_c01.ie_instrumentador = 'N') and ((r_c01.ie_medico = 'S') or (r_c01.ie_anestesista = 'S') or (r_c01.ie_auxiliar = 'S')) and (coalesce(position(r_c01.nm_profissional in t_objeto_row_w.nm_outros),0) = 0) then
				if (coalesce(t_objeto_row_w.nm_outros::text, '') = '') then
					t_objeto_row_w.nm_outros := r_c01.nm_profissional;
				else
					t_objeto_row_w.nm_outros := r_c01.nm_profissional ||', '||t_objeto_row_w.nm_outros;
				end if;
			end if;

			if (r_c01.ie_anestesista = 'S') and (coalesce(position(r_c01.nm_profissional in t_objeto_row_w.nm_anestesistas),0) = 0) then
				if (coalesce(t_objeto_row_w.nm_anestesistas::text, '') = '') then
					t_objeto_row_w.nm_anestesistas := r_c01.nm_profissional;
				else
					t_objeto_row_w.nm_anestesistas := r_c01.nm_profissional ||', '||t_objeto_row_w.nm_anestesistas;
				end if;
			end if;
		end if;
		end;
	end loop;
	RETURN NEXT t_objeto_row_w;
end if;

RETURN;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION surgery_pck.get_participantes (nr_cirurgia_p bigint) FROM PUBLIC;