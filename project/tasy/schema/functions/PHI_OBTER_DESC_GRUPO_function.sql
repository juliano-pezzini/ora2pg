-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION phi_obter_desc_grupo ( nr_seq_grupo_p grupo_desenvolvimento.nr_sequencia%type, nr_seq_idioma_p idioma.nr_sequencia%type default null) RETURNS varchar AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Objective: 
-------------------------------------------------------------------------------------------------------------------
Direct call: 
[  ]  Dictionary objects [  ] Tasy (Delphi/Java/HTML5) [  ] Portal [  ]  Reports [ ] Others:
 ------------------------------------------------------------------------------------------------------------------
Attention points: 
-------------------------------------------------------------------------------------------------------------------
References: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w		varchar(4000) := null;
nr_seq_idioma_w		idioma.nr_sequencia%type;


BEGIN

if (phi_is_base_philips = 'S') then
	begin
	
		nr_seq_idioma_w := coalesce(nr_seq_idioma_p, wheb_usuario_pck.get_nr_seq_idioma, 5);
	
		select	substr(coalesce(obter_desc_exp_idioma(gd.cd_exp_grupo, nr_seq_idioma_w), gd.ds_grupo), 1, 4000)
		into STRICT	ds_retorno_w
		from	grupo_desenvolvimento gd
		where	gd.nr_sequencia = nr_seq_grupo_p;
	end;
end if;

	return ds_retorno_w;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION phi_obter_desc_grupo ( nr_seq_grupo_p grupo_desenvolvimento.nr_sequencia%type, nr_seq_idioma_p idioma.nr_sequencia%type default null) FROM PUBLIC;
