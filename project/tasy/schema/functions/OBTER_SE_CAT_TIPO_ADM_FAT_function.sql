-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_cat_tipo_adm_fat (nr_atendimento_p bigint, cd_convenio_p bigint, cd_categoria_p text) RETURNS varchar AS $body$
DECLARE


ie_liberado_w	varchar(01)	:= 'S';
qt_regra_w	bigint;

BEGIN

select  count(*)
into STRICT	qt_regra_w
from  categ_tipo_admissao_fat a
where a.cd_convenio = cd_convenio_p
and a.cd_categoria = cd_categoria_p;

if (qt_regra_w	<> 0) then

  select count(*)
  into STRICT	qt_regra_w
  from  atendimento_paciente c,
        atend_categoria_convenio b,
        categ_tipo_admissao_fat a,
        subtipo_episodio sb,
        tipo_admissao_fat tf
  where  c.nr_atendimento = nr_atendimento_p
  and c.nr_atendimento = b.nr_atendimento
  and b.cd_convenio = a.cd_convenio
  and b.cd_categoria = a.cd_categoria
  and c.NR_SEQ_TIPO_ADMISSAO_FAT = a.NR_SEQ_TIPO_ADMISSAO_FAT
  and tf.nr_sequencia = a.nr_seq_tipo_admissao_fat
  and sb.nr_seq_tipo_admissao = tf.nr_sequencia
  and a.cd_convenio = cd_convenio_p
  and a.cd_categoria = cd_categoria_p;

  if (qt_regra_w	= 0) then
      ie_liberado_w :='N';
  end if;

end if;

return	ie_liberado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_cat_tipo_adm_fat (nr_atendimento_p bigint, cd_convenio_p bigint, cd_categoria_p text) FROM PUBLIC;
