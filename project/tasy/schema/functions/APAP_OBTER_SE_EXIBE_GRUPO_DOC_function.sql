-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION apap_obter_se_exibe_grupo_doc ( nr_seq_grupo_apap_p bigint, nr_seq_documento_secao_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE




qt_reg_w	bigint;
ie_profissional_w	varchar(15);

BEGIN

if	((nr_seq_grupo_apap_p IS NOT NULL AND nr_seq_grupo_apap_p::text <> '') or (nr_seq_documento_secao_p IS NOT NULL AND nr_seq_documento_secao_p::text <> '')) and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

   if (nr_seq_grupo_apap_p IS NOT NULL AND nr_seq_grupo_apap_p::text <> '') then
      select	count(*)
      into STRICT	   qt_reg_w
      from	   pep_apap_grupo_regra
      where	   nr_seq_grupo_apap	= nr_seq_grupo_apap_p;
   else
      select	count(*)
      into STRICT	   qt_reg_w
      from	   pep_apap_grupo_regra
      where	   nr_seq_documento_secao	= nr_seq_documento_secao_p;
   end if;

	if (qt_reg_w	> 0) then

		select	max(ie_profissional)
		into STRICT	   ie_profissional_w
		from	   usuario
		where	   nm_usuario	= nm_usuario_p;

      if (nr_seq_grupo_apap_p IS NOT NULL AND nr_seq_grupo_apap_p::text <> '') then
         select	count(*)
         into STRICT	   qt_reg_w
         from	   pep_apap_grupo_regra
         where	   nr_seq_grupo_apap	= nr_seq_grupo_apap_p
         and	   ie_profissional   = coalesce(ie_profissional_w,ie_profissional);
      else
         select	count(*)
         into STRICT	   qt_reg_w
         from	   pep_apap_grupo_regra
         where	   nr_seq_documento_secao	= nr_seq_documento_secao_p
         and	   ie_profissional         = coalesce(ie_profissional_w,ie_profissional);
      end if;

		if (qt_reg_w	= 0) then
			return 'N';
		end if;
	end if;

end if;
return	'S';

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION apap_obter_se_exibe_grupo_doc ( nr_seq_grupo_apap_p bigint, nr_seq_documento_secao_p bigint, nm_usuario_p text) FROM PUBLIC;

