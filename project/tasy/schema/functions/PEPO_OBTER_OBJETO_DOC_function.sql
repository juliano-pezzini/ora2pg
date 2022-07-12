-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pepo_obter_objeto_doc ( cd_item_p bigint, ie_tipo_retorno text default 'DI') RETURNS bigint AS $body$
DECLARE

/* ie_tipo_retorno                           
    DI - seq_dic_objeto
    IT - seq_item_pepo
*/
                                      
  nr_seq_dic_objeto_w bigint := 0;
  nr_seq_item_pepo_w bigint := 0;


BEGIN

      case cd_item_p
      when 1 then
          nr_seq_dic_objeto_w := 120885;
          nr_seq_item_pepo_w := 18;
      when 2 then
          nr_seq_dic_objeto_w := 337829;
          nr_seq_item_pepo_w := 62;
      when 3 then
          nr_seq_dic_objeto_w := 634086;
          nr_seq_item_pepo_w := 0;
      when 5 then
          nr_seq_dic_objeto_w := 120935;
          nr_seq_item_pepo_w := 52;
      when 6 then
          nr_seq_dic_objeto_w := 121480;
          nr_seq_item_pepo_w := 11;
      when 7 then
          nr_seq_dic_objeto_w := 121472;
          nr_seq_item_pepo_w := 11;
      when 8 then
          nr_seq_dic_objeto_w := 121464;
          nr_seq_item_pepo_w := 11;
      when 9 then
          nr_seq_dic_objeto_w := 121468;
          nr_seq_item_pepo_w := 11;
      when 10 then
          nr_seq_dic_objeto_w := 121460;
          nr_seq_item_pepo_w := 11;
      when 11 then
          nr_seq_dic_objeto_w := 121476;
          nr_seq_item_pepo_w := 11;
      when 12 then
          nr_seq_dic_objeto_w := 121487;
          nr_seq_item_pepo_w := 11;
      when 13 then
          nr_seq_dic_objeto_w := 339807;
          nr_seq_item_pepo_w := 16;
      when 14 then
          nr_seq_dic_objeto_w := 339811;
          nr_seq_item_pepo_w := 16;
      when 15 then
          nr_seq_dic_objeto_w := 1154813;
          nr_seq_item_pepo_w := 16;
      when 16 then
          nr_seq_dic_objeto_w := 120851;
          nr_seq_item_pepo_w := 58;
      when 17 then
          nr_seq_dic_objeto_w := 120841;
          nr_seq_item_pepo_w := 93;
      when 18 then
          nr_seq_dic_objeto_w := 132381;
          nr_seq_item_pepo_w := 43;
      when 19 then
          nr_seq_dic_objeto_w := 120989;
          nr_seq_item_pepo_w := 37;
      when 20 then
          nr_seq_dic_objeto_w := 120967;
          nr_seq_item_pepo_w := 46;
      when 21 then
          nr_seq_dic_objeto_w := 121362;
          nr_seq_item_pepo_w := 15;
      when 22 then
          nr_seq_dic_objeto_w := 121350;
          nr_seq_item_pepo_w := 15;
      when 23 then
          nr_seq_dic_objeto_w := 121376;
          nr_seq_item_pepo_w := 15;
      when 24 then
          nr_seq_dic_objeto_w := 121372;
          nr_seq_item_pepo_w := 15;
      when 25 then
          nr_seq_dic_objeto_w := 121358;
          nr_seq_item_pepo_w := 15;
      when 26 then
          nr_seq_dic_objeto_w := 121354;
          nr_seq_item_pepo_w := 15;
      else
          nr_seq_dic_objeto_w := 0;
          nr_seq_item_pepo_w := 0;
      end case;

      case ie_tipo_retorno
      when 'DI' then
        return nr_seq_dic_objeto_w;
      when 'IT' then
        return nr_seq_item_pepo_w;
      else
        return 0;
      end case;

  end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pepo_obter_objeto_doc ( cd_item_p bigint, ie_tipo_retorno text default 'DI') FROM PUBLIC;
