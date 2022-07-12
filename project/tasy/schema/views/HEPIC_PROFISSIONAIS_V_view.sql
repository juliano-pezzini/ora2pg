-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW hepic_profissionais_v (cd_pessoa_fisica, nm_pessoa_fisica, cd_cargo, ds_cargo) AS select   	a.cd_pessoa_fisica,
				a.nm_pessoa_fisica,
				b.cd_cargo,
				b.ds_cargo
       FROM medico c, pessoa_fisica a
LEFT OUTER JOIN cargo b ON (a.cd_cargo = b.cd_cargo)
WHERE c.cd_pessoa_fisica = a.cd_pessoa_fisica and c.ie_situacao = 'A' order by 	cd_pessoa_fisica;
