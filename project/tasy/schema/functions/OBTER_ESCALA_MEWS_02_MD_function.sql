-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_escala_mews_02_md (qt_freq_cardiaca_p bigint, qt_freq_resp_p bigint, qt_pa_sistolica_p bigint, ie_nivel_consciencia_p text, qt_temp_p bigint, ds_atributo_p text, nr_minimo_p bigint, nr_maximo_p bigint, nr_pontuacao_p bigint, ie_indice_p text, ie_tipo_p text ) RETURNS bigint AS $body$
DECLARE

  qt_pontuacao_w  bigint := 0;


BEGIN

    if ((qt_freq_cardiaca_p IS NOT NULL AND qt_freq_cardiaca_p::text <> '') and ie_tipo_p = 'FC')  then

	  if (nr_minimo_p IS NOT NULL AND nr_minimo_p::text <> '' AND nr_maximo_p IS NOT NULL AND nr_maximo_p::text <> '') and (coalesce(qt_freq_cardiaca_p, 0) >= nr_minimo_p) and (coalesce(qt_freq_cardiaca_p, 0) <= nr_maximo_p) then
        qt_pontuacao_w := qt_pontuacao_w + coalesce(nr_pontuacao_p, 0);
      elsif (coalesce(nr_minimo_p::text, '') = '' and (nr_maximo_p IS NOT NULL AND nr_maximo_p::text <> '')) and (coalesce(qt_freq_cardiaca_p, 0) <= nr_maximo_p) then
        qt_pontuacao_w := qt_pontuacao_w + coalesce(nr_pontuacao_p, 0);	
      elsif ((nr_minimo_p IS NOT NULL AND nr_minimo_p::text <> '') and coalesce(nr_maximo_p::text, '') = '') and (coalesce(qt_freq_cardiaca_p, 0) >= nr_minimo_p) then
        qt_pontuacao_w := qt_pontuacao_w + coalesce(nr_pontuacao_p, 0);	
      end if;

	end if;

    if ((qt_freq_resp_p IS NOT NULL AND qt_freq_resp_p::text <> '') and ie_tipo_p = 'FR')  then

	  if (nr_minimo_p IS NOT NULL AND nr_minimo_p::text <> '' AND nr_maximo_p IS NOT NULL AND nr_maximo_p::text <> '') and (coalesce(qt_freq_resp_p, 0) >= nr_minimo_p) and (coalesce(qt_freq_resp_p, 0) <= nr_maximo_p) then
        qt_pontuacao_w := qt_pontuacao_w + coalesce(nr_pontuacao_p, 0);
      elsif (coalesce(nr_minimo_p::text, '') = '' and (nr_maximo_p IS NOT NULL AND nr_maximo_p::text <> ''))  and (coalesce(qt_freq_resp_p,0) <= nr_maximo_p) then
        qt_pontuacao_w := qt_pontuacao_w + coalesce(nr_pontuacao_p, 0);	
      elsif ((nr_minimo_p IS NOT NULL AND nr_minimo_p::text <> '') and coalesce(nr_maximo_p::text, '') = '')  and (coalesce(qt_freq_resp_p,0) >= nr_minimo_p) then
        qt_pontuacao_w := qt_pontuacao_w + coalesce(nr_pontuacao_p, 0);	
      end if;

	end if;

    if ((qt_pa_sistolica_p IS NOT NULL AND qt_pa_sistolica_p::text <> '') and ie_tipo_p = 'PaS')  then

	  if (nr_minimo_p IS NOT NULL AND nr_minimo_p::text <> '' AND nr_maximo_p IS NOT NULL AND nr_maximo_p::text <> '') and (coalesce(qt_pa_sistolica_p, 0) >= nr_minimo_p) and (coalesce(qt_pa_sistolica_p, 0) <= nr_maximo_p) then
          qt_pontuacao_w := qt_pontuacao_w + coalesce(nr_pontuacao_p, 0);
        elsif (coalesce(nr_minimo_p::text, '') = '' and (nr_maximo_p IS NOT NULL AND nr_maximo_p::text <> '')) and (coalesce(qt_pa_sistolica_p, 0) <= nr_maximo_p) then
          qt_pontuacao_w := qt_pontuacao_w + coalesce(nr_pontuacao_p, 0);	
        elsif ((nr_minimo_p IS NOT NULL AND nr_minimo_p::text <> '') and coalesce(nr_maximo_p::text, '') = '') and (coalesce(qt_pa_sistolica_p, 0) >= nr_minimo_p) then
		  qt_pontuacao_w := qt_pontuacao_w + coalesce(nr_pontuacao_p, 0);	
		end if;

	end if;

    if ((qt_temp_p IS NOT NULL AND qt_temp_p::text <> '') and ie_tipo_p = 'T')  then

	  if (nr_minimo_p IS NOT NULL AND nr_minimo_p::text <> '' AND nr_maximo_p IS NOT NULL AND nr_maximo_p::text <> '') and (coalesce(qt_temp_p,0) >= nr_minimo_p) and (coalesce(qt_temp_p,0) <= nr_maximo_p) then
        qt_pontuacao_w := qt_pontuacao_w + coalesce(nr_pontuacao_p, 0);
      elsif (coalesce(nr_minimo_p::text, '') = '' and (nr_maximo_p IS NOT NULL AND nr_maximo_p::text <> ''))  and (coalesce(qt_temp_p,0) <= nr_maximo_p) then
        qt_pontuacao_w := qt_pontuacao_w + coalesce(nr_pontuacao_p, 0);	
      elsif ((nr_minimo_p IS NOT NULL AND nr_minimo_p::text <> '') and coalesce(nr_maximo_p::text, '') = '')  and (coalesce(qt_temp_p,0) >= nr_minimo_p) then
        qt_pontuacao_w := qt_pontuacao_w + coalesce(nr_pontuacao_p, 0);	
      end if;

	end if;

    if ((ie_nivel_consciencia_p IS NOT NULL AND ie_nivel_consciencia_p::text <> '') and ie_tipo_p = 'NC') then

	  if (ie_indice_p IS NOT NULL AND ie_indice_p::text <> '') and (coalesce(ie_nivel_consciencia_p,0) = ie_indice_p) then
        qt_pontuacao_w := qt_pontuacao_w + coalesce(nr_pontuacao_p, 0);
      end if;

	end if;

    return qt_pontuacao_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_escala_mews_02_md (qt_freq_cardiaca_p bigint, qt_freq_resp_p bigint, qt_pa_sistolica_p bigint, ie_nivel_consciencia_p text, qt_temp_p bigint, ds_atributo_p text, nr_minimo_p bigint, nr_maximo_p bigint, nr_pontuacao_p bigint, ie_indice_p text, ie_tipo_p text ) FROM PUBLIC;

