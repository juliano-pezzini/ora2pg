-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_sincronizar_seq () AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:   Sincronizar a sequence PLS_MONITOR_LOG_LOTE_SEQ com o valor máximo contido na tabela PLS_MONITOR_LOG_LOTE
----------------------------------------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [  ] Relatórios [ ] Outros:
 ----------------------------------------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/  nNr_Sequencia  PLS_MONITOR_LOG_LOTE.NR_SEQUENCIA%Type :=0;
  nVal_Seq       PLS_MONITOR_LOG_LOTE.NR_SEQUENCIA%Type :=0;
  vErro          varchar(1) := 'N';




BEGIN

  Begin
    Select MAX(Pls_Monitor_Log_Lote.Nr_Sequencia)
    Into STRICT   nNr_Sequencia
    From   Pls_Monitor_Log_Lote
;

    Select nextval('pls_monitor_log_lote_seq')
    Into STRICT   nVal_Seq

;
  Exception
    When Others Then
      vErro := 'S';
  End;





  If (coalesce(vErro,'N') = 'N') Then
    While nVal_Seq <= nNr_Sequencia Loop
      Begin
        Select nextval('pls_monitor_log_lote_seq')
        Into STRICT   nVal_Seq

;
      Exception
        When Others Then
          Null;
      End;
    End Loop;
  End If;


End;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sincronizar_seq () FROM PUBLIC;
