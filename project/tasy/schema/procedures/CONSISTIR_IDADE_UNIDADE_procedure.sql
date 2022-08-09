-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_idade_unidade ( cd_pessoa_fisica_p text, nr_seq_unidade_p bigint, ds_retorno_p INOUT text ) AS $body$
DECLARE

 
qt_idade_minima_w	real;
qt_idade_maxima_w	real;
qt_idade_w		real;
qt_idade_dias_min_w	smallint;
qt_idade_dias_max_w	smallint;
qt_idade_anos_w		real;
qt_idade_dias_w		bigint;

BEGIN
 
if	(cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '' AND nr_seq_unidade_p IS NOT NULL AND nr_seq_unidade_p::text <> '') then 
 
	select	obter_idade_pf(cd_pessoa_fisica_p,clock_timestamp(),'A') 
	into STRICT	qt_idade_anos_w 
	;
	 
	qt_idade_w := qt_idade_anos_w;
	 
 
 
	select	max(qt_idade_minima), 
		max(qt_idade_maxima), 
		max(qt_idade_dias_min), 
		max(qt_idade_dias_max) 
	into STRICT	qt_idade_minima_w, 
		qt_idade_maxima_w, 
		qt_idade_dias_min_w, 
		qt_idade_dias_max_w 
	from	unidade_atendimento 
	where	nr_seq_interno	=	nr_seq_unidade_p;	
	 
	 
	if (coalesce(qt_idade_dias_min_w::text, '') = '') and (coalesce(qt_idade_dias_max_w::text, '') = '') then 
 
		if (qt_idade_minima_w IS NOT NULL AND qt_idade_minima_w::text <> '') and (qt_idade_minima_w > qt_idade_w) then 
			ds_retorno_p := wheb_mensagem_pck.get_texto(306573, 'QT_IDADE_MINIMA=' || to_char(qt_idade_minima_w));
							-- A idade mínima permitida para o leito é #@QT_IDADE_MINIMA#@ ano(s). 
		end if;
 
		if (qt_idade_maxima_w IS NOT NULL AND qt_idade_maxima_w::text <> '') and (qt_idade_maxima_w < qt_idade_w) then 
			ds_retorno_p := wheb_mensagem_pck.get_texto(306574, 'QT_IDADE_MAXIMA=' || to_char(qt_idade_maxima_w));
							-- A idade máxima permitida para o leito é #@QT_IDADE_MAXIMA#@ ano(s). 
		end if;
	 
	else		 
			 
			select trunc(clock_timestamp()-to_date(obter_dados_pf(cd_pessoa_fisica_p,'DN'))) 
			into STRICT	qt_idade_dias_w 
			;
		 
			if (qt_idade_dias_min_w IS NOT NULL AND qt_idade_dias_min_w::text <> '') and (qt_idade_w = 0) and (qt_idade_dias_min_w > qt_idade_dias_w) then 
				ds_retorno_p := wheb_mensagem_pck.get_texto(779753, 'QT_IDADE_MINIMA=' || to_char(qt_idade_dias_min_w));
								-- A idade mínima permitida para o leito é #@QT_IDADE_MINIMA#@ dias(s). 
			end if;
			 
	 
			if (qt_idade_dias_max_w IS NOT NULL AND qt_idade_dias_max_w::text <> '') and (qt_idade_w = 0) and (qt_idade_dias_max_w < qt_idade_dias_w) then 
				ds_retorno_p := wheb_mensagem_pck.get_texto(306576, 'QT_IDADE_DIAS_MAX=' || to_char(qt_idade_dias_max_w));
								-- A idade máxima permitida para o leito é #@QT_IDADE_DIAS_MAX#@ dia(s). 
			elsif (qt_idade_dias_max_w IS NOT NULL AND qt_idade_dias_max_w::text <> '') and (qt_idade_w > 0) then 
				ds_retorno_p := wheb_mensagem_pck.get_texto(306576, 'QT_IDADE_DIAS_MAX=' || to_char(qt_idade_dias_max_w));
								-- A idade máxima permitida para o leito é #@QT_IDADE_DIAS_MAX#@ dia(s). 
			end if;
 
			if (qt_idade_minima_w IS NOT NULL AND qt_idade_minima_w::text <> '') and (qt_idade_w > 0) and (qt_idade_minima_w > qt_idade_w) then 
				ds_retorno_p := wheb_mensagem_pck.get_texto(306573, 'QT_IDADE_MINIMA=' || to_char(qt_idade_minima_w));
								-- A idade mínima permitida para o leito é #@QT_IDADE_MINIMA#@ ano(s). 
			end if;
 
			if (qt_idade_maxima_w IS NOT NULL AND qt_idade_maxima_w::text <> '') and (qt_idade_w > 0) and (qt_idade_maxima_w < qt_idade_w) then 
				ds_retorno_p := wheb_mensagem_pck.get_texto(306574, 'QT_IDADE_MAXIMA=' || to_char(qt_idade_maxima_w));
								-- A idade máxima permitida para o leito é #@QT_IDADE_MAXIMA#@ ano(s). 
			end if;			
				 
	end if;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_idade_unidade ( cd_pessoa_fisica_p text, nr_seq_unidade_p bigint, ds_retorno_p INOUT text ) FROM PUBLIC;
