-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION tax_dmed_ir_pck.exists_paying_service (attendance_p atendimento_paciente.nr_atendimento%type) RETURNS bigint AS $body$
DECLARE

      response bigint;

BEGIN
      select  count(1)
      into STRICT    response
      from    atendimento_pagador 
      where   nr_atendimento = attendance_p;
      return  response;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION tax_dmed_ir_pck.exists_paying_service (attendance_p atendimento_paciente.nr_atendimento%type) FROM PUBLIC;