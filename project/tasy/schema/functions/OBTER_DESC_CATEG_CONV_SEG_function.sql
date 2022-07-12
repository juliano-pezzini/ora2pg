-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_categ_conv_seg ( nr_atendimento_p atend_categoria_convenio.nr_atendimento%type) RETURNS varchar AS $body$
DECLARE


ds_categoria_segurado_w conv_categoria_segurado.ds_categoria_segurado%type;


BEGIN

 begin
    select b.ds_categoria_segurado
    into STRICT   ds_categoria_segurado_w
    from   atend_categoria_convenio a, conv_categoria_segurado b
    where  b.nr_sequencia = a.nr_seq_conv_categ_seg
    and    a.nr_seq_interno = (SELECT max(a2.nr_seq_interno) from atend_categoria_convenio a2 where a2.nr_atendimento = a.nr_atendimento)
    and    a.nr_atendimento = nr_atendimento_p;
 exception when others then
       ds_categoria_segurado_w := null;
 end;

 return  ds_categoria_segurado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_categ_conv_seg ( nr_atendimento_p atend_categoria_convenio.nr_atendimento%type) FROM PUBLIC;

